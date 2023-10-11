//页面Event
function InitCCScreeningWinEvent(obj){	
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
		if (LocFlag==1) {
			obj.gridAdmInfo();   //加载临床科室患者明细
			obj.gridAdmInfoLoad();
			$('#divAccordion').accordion({
				onSelect:function(title,index){
					if (index==1) {
						obj.gridDutyList();  //加载责任患者列表
						obj.gridDutyListLoad();
					}else {
						obj.gridAdmInfo();
						obj.gridAdmInfoLoad();
					}
				}
			}); 
		}
		
		$HUI.tabs("#divTabs",{
			onSelect:function(title,index){				
				if (index==0){  //待处理
					$("#divtab0").css('display','block');
					obj.ShowType = 1;
					obj.gridLocInf();
					obj.gridLocInfLoad(); 
				}
				if (index==1){  //已处理
					obj.ShowType = 4;
					$("#divtab1").css('display','block');
					obj.gridLocInf();
					obj.gridLocInfLoad(); 					
				}	
				if (index==2){  //确诊未上报报告
					obj.ShowType = 2;
					$("#divtab2").css('display','block');
					obj.gridLocInf();
					obj.gridLocInfLoad(); 
				}
				if (index==3){  //报告未审
					obj.ShowType = 5;
					$("#divtab3").css('display','block');
					obj.gridLocInf();
					obj.gridLocInfLoad(); 
				}
				if (index==4){  //需关注
					obj.ShowType = 3;
					$("#divtab4").css('display','block');				
					obj.gridLocInf();
					obj.gridLocInfLoad(); 
				}
				if (index==5){  //全部
					obj.ShowType = "";
					$("#divtab5").css('display','block');
					obj.gridLocInf();
					obj.gridLocInfLoad(); 
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
					$('#aPatName').val('');
					$('#aRegNo').val('');
					$('#aMrNo').val('');
					$('#aBed').val('');
					$('#divMain').empty();        //清空主区域内容
					$('#divNoResult').attr("style","display:block");
					if (LocFlag==1) {
						obj.gridAdmInfoLoad();        //重新加载临床科室患者明细
					}else {
						obj.gridLocAdmInfo="";        
						obj.gridLocInfLoad();         //加载感染科室疑似筛查汇总  
					}
				}else{
					$('#aDateFrom').datebox('enable');
					$('#aDateTo').datebox('enable');
					$('#aDateFrom').datebox('setValue',Common_GetCalDate(-30));
					$('#aDateTo').datebox('setValue',Common_GetDate(new Date()));
					$('#aPatName').val('');
					$('#aRegNo').val('');
					$('#aMrNo').val('');
					$('#aBed').val('');
					$('#divMain').empty();        //清空主区域内容
					$('#divNoResult').attr("style","display:block");
					if (LocFlag==1) {
						obj.gridAdmInfoLoad();        //重新加载临床科室患者明细
					}else {
						obj.gridLocAdmInfo=""; 
						obj.gridLocInfLoad();         //加载感染科室疑似筛查汇总  
					}
				}
			}
		});

		//更多按钮
		$('#btnMore').on('click', function(){ 	
			if ($(this).hasClass('expanded')){  //已经展开 隐藏
				$(this).removeClass('expanded');
				$("#btnMore")[0].innerText=$g("更多");
				$('#MSearchItem').css('display','none');
			}else{
				$(this).addClass('expanded');
				$("#btnMore")[0].innerText=$g("隐藏");
				$('#MSearchItem').css('display','block');
			}
		});
		
		//疑似按钮改变事件
		$HUI.checkbox("[name='chkIsInf']",{  
			onCheckChange:function(e,value){
				$('#divMain').empty();           //清空主区域内容
				$('#divNoResult').attr("style","display:block");
				$('#aPatName').val('');
				$('#aRegNo').val('');
				$('#aMrNo').val('');
				$('#aBed').val('');
				if (LocFlag==1) {
					obj.gridAdmInfoLoad();        //重新加载临床科室患者明细
				}else {
					obj.gridLocAdmInfo=""; 
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
				if (DateDiff(newValue,aDateTo)>31) {
					$HUI.tooltip("#DateTip",{
						content: '开始、结束日期间隔超出31天范围',
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
					obj.gridLocAdmInfo=""; 
					obj.gridLocInfLoad();         //加载感染科室疑似筛查汇总  
				}
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
				if (DateDiff(aDateFrom,newValue)>31) {
					$('#DateTip').tooltip({
						position: 'right',
						content: '<span style="color:#fff">This is the tooltip message.</span>',
						onShow: function(){
							$(this).tooltip('tip').css({
								backgroundColor: '#666',
								borderColor: '#666'
							});
						}
					});
					$HUI.tooltip("#DateTip",{
						content: '开始、结束日期间隔超出31天范围',
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
					obj.gridLocAdmInfo=""; 
					obj.gridLocInfLoad();         //加载感染科室疑似筛查汇总  
				}
				
			}
		});
		
		//配置按钮
		$('#btnConfig').on('click', function(){ 
			Common_ComboToLoc('cboLoc',$("#cboHospital").combobox('getValue'));
			//工作组类型
   			$HUI.combobox("#cboLocGrpType", {
		        url:$URL,
		        editable: true,       
		        defaultFilter:4,     
		        valueField: 'ID',
		        textField: 'DicDesc',
		        onBeforeLoad: function (param) {
		            param.ClassName = 'DHCHAI.BTS.DictionarySrv';
		            param.QueryName = 'QryDic';
		            param.aTypeCode = 'CCLocGroupType';
		            param.aActive = '1';
		            param.ResultSetType = 'array'
		        },
		        onLoadSuccess:function(){  
		            var data=$(this).combobox('getData');
		            var len = data.length;
		            var DicID="",DicDesc="",DicCode="";
		            for (var i=0;i<len;i++) {
			            DicID = data[i]['ID'];
			            DicDesc = data[i]['DicDesc'];
			            DicCode = data[i]['DicCode'];
			            if (DicCode==1) continue;
		            }
		            $(this).combobox('select',DicID);
		            $(this).combobox('disable');		           
		        }
		    });

			$('#cboLoc').combobox('clear');
			$('#txtPhone').val("");
			$('#cboUser').lookup('setText',$.LOGON.USERDESC);
			obj.UserID = $.LOGON.USERID;
			$('#dtEffect').datebox('setValue', Common_GetDate(new Date()));
			$('#dtExpiry').datebox('setValue',"");
	 		$('#LocUserDialog').show();
			
			$('#LocUserDialog').dialog({
				title: '科室责任人维护',
				iconCls:"icon-w-paper",
				modal: true,
				isTopZindex:false,
				buttons:[{
					text:'保存',
					handler:function(){
						obj.SaveLocGroup();
					}
				},{
					text:'关闭',
					handler:function(){
						$HUI.dialog('#LocUserDialog').close();
					}
				}]
			});
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
					obj.gridLocAdmInfo=""; 
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
					obj.gridLocAdmInfo=""; 
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
					obj.gridLocAdmInfo=""; 
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
					obj.gridLocAdmInfo=""; 
					obj.gridLocInfLoad();         //加载感染科室疑似筛查汇总  
				}
			}
		});
		//导出
		$('#btnExport').bind('click', function (e) {
			var aTypeFlag = (Common_RadioValue('radAdmStatus') ? Common_RadioValue('radAdmStatus'):'1');
			var aDateFrom = $('#aDateFrom').datebox('getValue');
			var aDateTo = $('#aDateTo').datebox('getValue');
			var aHospIDs = $('#cboHospital').combobox('getValue');
			var aViewFlag = 2;
			var aGroupUser = $('#cboGroup').combobox('getText');
			var aPatInfo = $('#aPatName').val()+"^"+$('#aRegNo').val()+"^"+$('#aMrNo').val()+"^"+$('#aBed').val();
			var aShowType = obj.ShowType;
			var param = "aTypeFlag=" + aTypeFlag + "&aDateFrom="+ aDateFrom +"&aDateTo="+ aDateTo +"&aHospIDs="+ aHospIDs +"&aViewFlag="+ aViewFlag +"&aGroupUser="+ aGroupUser +"&aPatInfo="+ aPatInfo +"&aShowType="+ aShowType
			
			var strUrl = "./dhcma.hai.ir.ccscreeningexport.csp?"+ param +"&PageType=WinOpen";
			websys_showModal({
				url:strUrl,
				title:$g('疑似病例筛查信息总览'),
				iconCls:'icon-w-paper',  
				originWindow:window,
				width:window.screen.availWidth-40,
				height:window.screen.availHeight-80,
				onBeforeClose:function(){}  //若无词句,IE下打开一份报告关闭后，摘要无法关闭
			});
		});
	}
	
	//加载用户公共方法
	$("#cboUser").lookup({
		panelWidth:238,
		url:$URL,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		valueField: 'ID',
		textField: 'UserDesc',
		queryParams:{
			ClassName: 'DHCHAI.BTS.SysUserSrv',
			QueryName: 'QrySysUserList',
			aIsActive: 1
		},
		columns:[[  
			{field:'UserCode',title:$g('工号'),width:90},
			{field:'UserDesc',title:$g('姓名'),width:100}			
		]],
		onBeforeLoad:function(param){
			var desc=param['q']; 
			param = $.extend(param,{aUserName:desc}); //将参数q转换为类中的参数
		},
		onSelect:function(index,rowData){
			 obj.UserID=rowData['ID'];
		},
		pagination:true,
	    showPageList:false, showRefresh:false,displayMsg:'',
		loadMsg:'正在查询',
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		minQueryLen:1             //isCombo为true时，可以搜索要求的字符最小长度
	});

	obj.SaveLocGroup = function(){
		var errinfo = "";
		var GrpType=$("#cboLocGrpType").combobox('getValue');
		var UserID = obj.UserID;
		var LocID = $('#cboLoc').combobox('getValue');
		var Phone = $('#txtPhone').val();
		var EffectDate = $('#dtEffect').datebox("getValue");
		var ExpiryDate = $('#dtExpiry').datebox("getValue");
		var IsActive = ($("#chkIsActive").checkbox('getValue')? 1 : 0);
		if (!GrpType){
			errinfo = errinfo + $g("请选择工作组类型!")+"<br>";
		}
		if (!LocID) {
			errinfo = errinfo + $g("请重新填科室信息!")+"<br>";
		}
		if (!UserID) {
			errinfo = errinfo + $g("请重新填写用户信息!")+"<br>";
		}
		if (!Phone) {
			errinfo = errinfo + $g("请填写手机号!")+"<br>";
		}
		if ((!EffectDate)&&(ExpiryDate)) {
			errinfo = errinfo +$g("请填写生效日期!")+"<br>";
		}
		if ((EffectDate)&&(ExpiryDate)&&(Common_CompareDate(EffectDate,ExpiryDate))) {
			errinfo = errinfo +$g("生效日期不能大于截止日期!")+"<br>";
		}
		var isMblNum = /^[1][3,4,5,7,8,9][0-9]{9}$/;
        var isPhNum = /^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/;
        if ((Phone)&&(!isMblNum.test(Phone) && !isPhNum.test(Phone))) {
           	errinfo = errinfo + $g("手机号格式错误!")+"<br>";
        }
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return ;
		}
		var InputStr="";
		InputStr += "^" + LocID;
		InputStr += "^" + GrpType;
		InputStr += "^" + UserID;
		InputStr += "^" + Phone;
		InputStr += "^" + $.LOGON.USERID;
		InputStr += "^" + EffectDate;
		InputStr += "^" + ExpiryDate;
		InputStr += "^" + IsActive;
		
		var flg = $m({
			ClassName:"DHCHAI.IRS.CCLocGroupSrv",
			MethodName:"Update",
			aInputStr:InputStr,
		},false);
		if (parseInt(flg)> 0) {
			$HUI.dialog('#LocUserDialog').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		}else{
			$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
		}
	}
	
	//同步科室当天数据
	SyncAdmByLoc =  function() {
		loadingWindow2();
		window.setTimeout(function () {			
			var Count= $m ({
				ClassName:'DHCHAI.DI.DHS.SyncHisInfo',
				MethodName:'SyncAdmByDate',
				aSCode:$.LOGON.HISCode,
				aDateFrom:Common_GetDate(new Date()),
				aDateTo:Common_GetDate(new Date()),
				aLocID:$.LOGON.XLocID   //HIS的就诊科室,非院感同步后的科室
			},false);
			if (Count>0) {
				obj.gridAdmInfoLoad();
			}
			disLoadWindow(); 
		}, 100); 		
		
	}
	//加载临床科室患者明细
	obj.gridAdmInfoLoad = function(){
		var PatInfo = $('#aPatName').val()+"^"+$('#aRegNo').val()+"^"+$('#aMrNo').val()+"^"+$('#aBed').val();
		$cm ({
			ClassName:'DHCHAI.IRS.CCScreeningSrv',
			QueryName:'QrySuRulePatList',
			aTypeFlag:(Common_RadioValue('radAdmStatus') ? Common_RadioValue('radAdmStatus'):'1'),
			aDateFrom:$('#aDateFrom').datebox('getValue'), 
			aDateTo:$('#aDateTo').datebox('getValue'), 
			aLocID:$.LOGON.LOCID,
			aIsInf:($("#chkIsInf").checkbox('getValue') ? 1: ''), 
			aPatInfo:PatInfo,
			aCLABSIFlag:CLABSIFlag,
			page:1,      //可选项，页码，默认1			
			rows:999    //可选项，获取多少条数据，默认50
		},function(rs){
			$('#gridAdmInfo').datagrid('loadData', rs);				
		});
    }
	
	//加载临床责任患者明细
	obj.gridDutyListLoad = function(){	
		$cm ({
			ClassName:'DHCHAI.IRS.CCScreeningSrv',
			QueryName:'QryDutyPatList',
			aLocID:$.LOGON.LOCID,
			page:1,      //可选项，页码，默认1			
			rows:999    //可选项，获取多少条数据，默认50
		},function(rs){
			$('#gridDutyList').datagrid('loadData', rs);				
		});
    }
	
	//加载感染科室疑似筛查汇总
	obj.gridLocInfLoad = function(){	
		var PatInfo = $('#aPatName').val()+"^"+$('#aRegNo').val()+"^"+$('#aMrNo').val()+"^"+$('#aBed').val();
		var GroupID=$('#cboGroup').combobox('getValue');
		var GroupDesc=(GroupID ? $('#cboGroup').combobox('getText'):'');
		$cm({
			ClassName:"DHCHAI.IRS.CCScreeningSrv",
			QueryName:"QrySuRuleLocList",
			aTypeFlag:(Common_RadioValue('radAdmStatus') ? Common_RadioValue('radAdmStatus'):'1'),
			aDateFrom:$('#aDateFrom').datebox('getValue'), 
			aDateTo:$('#aDateTo').datebox('getValue'), 
			aHospIDs:$('#cboHospital').combobox('getValue'), 
			aViewFlag:2,	
			aGroupUser:GroupDesc,
			aPatInfo:PatInfo,
			aShowType:obj.ShowType,	
			aCLABSIFlag:CLABSIFlag,			
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
			aTypeFlag:(Common_RadioValue('radAdmStatus') ? Common_RadioValue('radAdmStatus'):'1'),
			aDateFrom:$('#aDateFrom').datebox('getValue'), 
			aDateTo:$('#aDateTo').datebox('getValue'), 
			aLocID:LocID,
			aIsInf:'', 
			aPatInfo:PatInfo,
			aShowType:obj.ShowType,
			aCLABSIFlag:CLABSIFlag	
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