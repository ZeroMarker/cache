//页面Event
function InitVAEScreeningWinEvent(obj){	
    //弹出加载层
	function loadingWindow() {	
	    var left = ($(window).outerWidth(true)) / 2; 
		var top = ($(window).height() - 35) / 2; 
		var height = $(window).height() * 2; 
 		$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: height,opacity: .7,'z-index': 5000}).appendTo("#divScreen"); 
 		$("<div class=\"datagrid-mask-msg\"></div>").html("数据加载中,请稍候...").appendTo("#divScreen").css({ display: "block", left: left, top: top }); 
	}
	
	//弹出加载层
	function loadingWindow2() {	
	    var left = ($(window).outerWidth(true)) / 2; 
		var top = ($(window).height() - 35) / 2; 
		var height = $(window).height() * 2; 
 		$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: height ,opacity: .7,'z-index': 5000}).appendTo("#divScreen"); 
 		$("<div class=\"datagrid-mask-msg\"></div>").html("数据同步中,请稍候...").appendTo("#divScreen").css({ display: "block", left: left, top: top }); 
	}
	
	//取消加载层  
	function disLoadWindow() {
	    $(".datagrid-mask").remove();
	    $(".datagrid-mask-msg").remove();
	}
	
    obj.LoadEvent = function(args){ 	   
		$HUI.tabs("#divTabs",{
			onSelect:function(title,index){				
				if (index==0){  //待处理
					$("#divtab0").css('display','block');
					obj.ShowType = 1;
					obj.gridLocVAE();
					obj.gridLocVAELoad(); 
				}
				if (index==1){  //已处理
					obj.ShowType = 2;
					$("#divtab1").css('display','block');
					obj.gridLocVAE();
					obj.gridLocVAELoad(); 					
				}
				if (index==2){  //全部
					obj.ShowType = 9;
					$("#divtab2").css('display','block');
					obj.gridLocVAE();
					obj.gridLocVAELoad(); 					
				}
				obj.gridLocAdmInfo="";        //防止选中明细列表后切换页签再选择科室列表无法展示结果	
				$('#divMain').empty();        //清空主区域内容
				$('#divNoResult').attr("style","display:block");
			}
		});
		
		
	    //在院、出院单选事件
		$HUI.radio("[name='radAdmStatus']",{  
			onChecked:function(e,value){
				var AdmStatus = $(e.target).val();   //当前选中的值
				if (AdmStatus==1) {
					$('#aDateFrom').datebox('clear');
					$('#aDateTo').datebox('clear');					
					$('#aDateFrom').datebox('disable');
					$('#aDateTo').datebox('disable');
					$('#divMain').empty();        //清空主区域内容
					$('#divNoResult').attr("style","display:block");
					obj.gridLocAdmInfo=""; 
					obj.gridLocVAELoad();         //加载感染科室疑似筛查汇总
				}else{
					$('#aDateFrom').datebox('enable');
					$('#aDateTo').datebox('enable');
					$('#aDateFrom').datebox('setValue',Common_GetCalDate(-30));
					$('#aDateTo').datebox('setValue',Common_GetDate(new Date()));
					$('#divMain').empty();        //清空主区域内容
					$('#divNoResult').attr("style","display:block");
					obj.gridLocAdmInfo=""; 
					obj.gridLocVAELoad();         //加载感染科室疑似筛查汇总
				}
			}
		});
		//日期改变事件
		$('#aDateFrom').datebox({
			onChange: function(newValue, oldValue){
				var aDateTo = $('#aDateTo').datebox('getValue');
				
				if (Common_CompareDate(newValue,aDateTo)>0) {
					$HUI.tooltip("#DateTip",{
						content: '开始日期不能大于结束日期',
						position:'bottom'
					}).show();
					return;
				}
				if (Common_CompareDate(newValue,Common_GetDate(new Date()))>0) {
					$HUI.tooltip("#DateTip",{
						content: '开始日期不能大于当前日期',
						position:'bottom'
					}).show();
					
					return;
				}
				$HUI.tooltip("#DateTip").destroy();
				
				$('#divMain').empty();           //清空主区域内容
				$('#divNoResult').attr("style","display:block");
				obj.gridLocAdmInfo="";
				obj.gridLocVAELoad();         //加载感染科室疑似筛查汇总
			}
		});
		
		//日期改变事件
		$('#aDateTo').datebox({
			onChange: function(newValue, oldValue){
				var aDateFrom = $('#aDateFrom').datebox('getValue');
		       
				if (Common_CompareDate(aDateFrom,newValue)>0) {	
					$HUI.tooltip("#DateTip",{
						content: '开始日期不能大于结束日期',
						position:'bottom',
						hideDelay: 1000
					}).show();
					return;
				}
				$('#divMain').empty();           //清空主区域内容
				$('#divNoResult').attr("style","display:block");
				obj.gridLocAdmInfo=""; 
				obj.gridLocVAELoad();         //加载感染科室疑似筛查汇总 
			}
		});
	}
	
	//加载科室VAE筛查汇总
	obj.gridLocVAELoad = function(){
		$cm({
			ClassName:"DHCHAI.IRS.VAEScreeningSrv",
			QueryName:"QrySuRuleLocList",
			aTypeFlag:(Common_RadioValue('radAdmStatus') ? Common_RadioValue('radAdmStatus'):'1'),
			aDateFrom:$('#aDateFrom').datebox('getValue'), 
			aDateTo:$('#aDateTo').datebox('getValue'), 
			aHospIDs:$('#cboHospital').combobox('getValue'), 
			aViewFlag:2,
			aShowType:obj.ShowType,				
			page:1,      //可选项，页码，默认1
			rows:999    //可选项，获取多少条数据，默认50
		},function(rs){
			$('#gridLocVAE').datagrid('loadData', rs);
		});
	}
	
	obj.gridAdmInfo_onSelect= function (pindex,rindex,objAdm){	
		if ((pindex>-1)&&(rindex>-1)) {		
			$('#gridLocVAE').datagrid('selectRow',pindex);  
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
	
	obj.gridLocVAE_onSelect= function (pindex,rindex,objLocInf){
		//清除明细表格选中行
		if (obj.gridLocAdmInfo) {
			obj.gridLocAdmInfo.clearSelections();
		}
		if (!objLocInf) return;
		$('#divMain').empty();
		var LocID = objLocInf.LocID;
	
		obj.PatList = $cm({
			ClassName:'DHCHAI.IRS.VAEScreeningSrv',
			QueryName:'QrySuRulePatList',
			aTypeFlag:(Common_RadioValue('radAdmStatus') ? Common_RadioValue('radAdmStatus'):'1'),
			aDateFrom:$('#aDateFrom').datebox('getValue'), 
			aDateTo:$('#aDateTo').datebox('getValue'), 
			aLocID:LocID,
			aShowType:obj.ShowType,
			aHospIDs:$('#cboHospital').combobox('getValue'),
			aViewFlag:2	
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
 	obj.gridScreen_onSelect= function (pindex,rindex,ScreenInfo){
		if (!ScreenInfo) return;
		var RstID = ScreenInfo.xRstID;
		obj.gridSequenceLoad(obj.EpisodeID,RstID);	
	}
}