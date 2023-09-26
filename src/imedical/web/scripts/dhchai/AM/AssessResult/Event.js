//页面Event
function InitAssResultWinEvent(obj){	
    
    //弹出加载层
	function loadingWindow() {	
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
		$('#AssessResult').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		  
		$('#btnExport').on('click', function(){
	     	obj.btnExport_click();
     	});
		
		$('#btnSynTask').on('click', function(){
			var ModelID =  $('#cbgModel').combogrid('getValue');
			if (ModelID>0) {
				loadingWindow();		
				window.setTimeout(function () {			
					var Count= $m ({
						ClassName:'DHCHAI.AMC.CSAssessTask',
						MethodName:'ManualTask',
						aModelDr:ModelID  //HIS的就诊科室,非院感同步后的科室
					},false);
					if (Count>0) {
						obj.gridAssResultLoad();
					}
					disLoadWindow(); 
				}, 100); 		
			}else {
				$.messager.alert("提示", "先选择评估模型再执行任务", 'info');
			}	
     	});
     	
	   	$HUI.combogrid('#cbgModel',{
			onSelect:function(rows){
				obj.gridAssResultLoad();		
				/*
				var ModelID = $('#cbgModel').combogrid('getValue');
				obj.gridAssResult.load({
					ClassName:'DHCHAI.AMS.AssessResultSrv',
					QueryName:'QryAssessResult',
					aModelDr:ModelID
				});
				*/
			}
		});
	}
	
	
	//窗体初始化
	obj.ResultDialog = function () {
		$('#ResultEdit').dialog({
			title:'处置操作',
			iconCls:'icon-w-edit',
			modal: true,
			isTopZindex:true,
			buttons:[{
				text:'保存',
				handler:function(){
					var Status=$('#cboStatus').combobox('getValue'); 
					var DiagDate=$('#dtDiagDate').datebox('getValue'); 
					var DiagNote = $.trim($('#txtDiagNote').val());
					var UserID = $.LOGON.USERID;	
					if (!Status) {
						$.messager.alert("提示","选择处置状态!",'info');
						return true;
					}
					if ((Status!=0)&&(!DiagDate)) {
						$.messager.alert("提示","填写确诊日期!",'info');
						return true;
					}
					if (Common_CompareDate(DiagDate,Common_GetDate(new Date()))>0){
						$.messager.alert("提示","确诊日期不能晚于当前日期!",'info');
						return true;
					}
					
					if (!DiagNote) {
						$.messager.alert("提示","请填写依据!",'info');
						return true;
					}
	                var inputStr = obj.RecRowID;
					inputStr = inputStr + "^" + Status;
					inputStr = inputStr + "^" + DiagDate;	
					inputStr = inputStr + "^" + DiagNote;
					inputStr = inputStr + "^" + UserID;
				   
					$m({
						ClassName:"DHCHAI.AM.AssessResult",
						MethodName:"ChangeStatus",
						aInputStr:inputStr, 
						aSeparete:"^"
					},function(txt){
						if (txt>0) {
							$.messager.popover({msg: '处置成功！',type:'success',timeout: 1000});
							obj.RecRowID="";
							$HUI.dialog('#ResultEdit').close();
							obj.gridAssResultLoad(); //刷新
						}else {
							$.messager.alert("错误提示","处置失败!",'error');
							return true;
						}
					});					
					
				}
			},{
				text:'关闭',
				handler:function(){$HUI.dialog('#ResultEdit').close();}
			}]
		});
	}
	 //处置显示
	obj.ResultEdit = function(aID,aStatus,aDiagDate,aDiagNote){
		//初始清空数据
		$('#cboStatus').combobox('clear');
		$('#dtDiagDate').datebox('clear');
		$('#dtDiagDate').datebox('enable');
		$('#txtDiagNote').val('');
		
		$('#ResultEdit').show();
		obj.ResultDialog();
		
		//加载存在数据
		obj.RecRowID = aID;
		if(aStatus!=-1) {
			$('#cboStatus').combobox('setValue',aStatus); 
		}
		if (aStatus==0) {
			$('#dtDiagDate').datebox('disable');
		}
		$('#dtDiagDate').datebox('setValue',aDiagDate); 
		$('#txtDiagNote').val(aDiagNote); 
	
	}
	
	//摘要信息
	obj.OpenView = function(aEpisodeID){
		var t=new Date();
		t=t.getTime();
		var strUrl = "./dhchai.ir.view.main.csp?PaadmID=" + aEpisodeID + "&PageType=WinOpen&t=" + t;
		websys_showModal({
			url:strUrl,
			title:'医院感染集成视图',
			iconCls:'icon-w-paper',  
			width:'95%',
			height:'95%'
		});
	}
	//打开报告
    obj.btnDetail_Click =function(aReportID,aEpisodeID) {
	    var Type =1;
		var NewBabyFlg  = $m({
			ClassName:"DHCHAI.DP.PAAdm",
			MethodName:"GetNewBabyById",
			id:aEpisodeID
		},false);
	
		if (NewBabyFlg=="1"){
			Type = 2;
		}		
		if (Type == '1') {
			var strTitle = '医院感染报告';
			var strUrl="dhcma.hai.ir.inf.report.csp?1=1&Paadm=" + aEpisodeID + "&ReportID="+ aReportID + t;
		}else if(Type == '2') {
			var strTitle = '新生儿医院感染报告';
			var strUrl="dhcma.hai.ir.inf.nreport.csp?1=1&Paadm=" + aEpisodeID + "&ReportID="+ aReportID + t;	   
		}	
		websys_showModal({
			url:strUrl,
			title:strTitle,
			iconCls:'icon-w-epr',  
			width:1320,
			height:'95%'
		});
	}
	
	//处置鼠标提示
	obj.SreenLogTip = function(aEpisodeID) {
		$m({
			ClassName:'DHCHAI.AMS.AssessResultSrv',
			QueryName:'QryScreenLog',
			aEpisodeID:aEpisodeID
		},function(jsonData){
		 
			var json = JSON.parse(jsonData);
			var htmlStr ='<div><span style="line-height:25px;">处置操作明细：</span></br>';
			for (var index =0; index< json.total; index++) {
				var Status = json.rows[index].Status;
				var UserDesc = json.rows[index].UserDesc;
				var ActDate = json.rows[index].ActDate;
				var ActTime = json.rows[index].ActTime;
				htmlStr +='<span style="line-height:25px;">'+(index+1)+". <span style='color:blue'>("+Status+")</span> "+UserDesc+" "+ActDate+" "+ActTime+'</span></br>';	
			}
			htmlStr +='</div>';
		 
			$("#ScreenLog"+aEpisodeID).popover({
				width:'300px',
				content:htmlStr,
				trigger:'hover',
				placement:'left',
				type:'html'
			});
			$("#ScreenLog"+aEpisodeID).popover('show');    
		});		
	}
	//导出
	obj.btnExport_click  = function(){
		var rows = obj.gridAssResult.getRows().length; 		
		if (rows>0) {
			$('#AssessResult').datagrid('toExcel','疑似病例筛查评估.xls');
		}else {
			$.messager.alert("提示", "无数据记录,不允许导出", 'info');
		}	
	}
	
	//加载临床责任患者明细
	obj.gridAssResultLoad = function(){
		$("#AssessResult").datagrid("loading");
		$cm ({
			ClassName:'DHCHAI.AMS.AssessResultSrv',
			QueryName:'QryAssessResult',
			aModelDr:$('#cbgModel').combogrid('getValue'),
			aInfPos:$('#cboInfPos').combobox('getValue'),
			ResultSetType:'array',
			page:1,      //可选项，页码，默认1			
			rows:200    //可选项，获取多少条数据，默认50
		},function(rs){
			$('#AssessResult').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		})
    }
    
}
