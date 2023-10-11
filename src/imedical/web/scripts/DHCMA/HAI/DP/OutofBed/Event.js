//页面Event
function InitOutofBedWinEvent(obj){	
	obj.LoadEvent = function(args){
		$('#OutofBed').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0	 
		 	
		//医院表格联动
		$HUI.combobox('#cboHosp',{
			onSelect:function(data){
				var HospID = data.ID;
				Common_ComboToLoc("cboLoc",HospID,"","I|E","E");
				obj.gridOutofBedLoad();
			}
		});
		$HUI.combobox('#cboLoc',{
			onChange:function(data){
				obj.gridOutofBedLoad();
			}
		});
		
		//查询
		$('#btnQuery').on('click', function(){
			obj.btnQuery_click();
		});
	}
	
	obj.btnQuery_click = function() {	
		var DateFrom = $('#aDateFrom').datebox('getValue');
		var DateTo = $('#aDateTo').datebox('getValue');
	
		if (Common_CompareDate(DateFrom,DateTo)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!");
			return;
		}
		obj.gridOutofBedLoad();
	}
	
		
	//窗体初始化
	obj.OprStatusDialog = function (aAdmDate,aAdmTime) {
		$('#OprStatusEdit').dialog({
			title:'标记出院时间',
			iconCls:'icon-w-edit',
			modal: true,
			isTopZindex:true,
			buttons:[{
				text:'保存',
				handler:function(){				
					var DischDate=$('#dtDischDate').datebox('getValue'); 
					var DischTime=$('#dtDischTime').timespinner('getValue');
								
					if (Common_CompareDate(DischDate,Common_GetDate(new Date()))>0){
						$.messager.alert("提示","标记出院日期不能晚于当前日期!",'info');
						return true;
					}
				
					if ((DischDate==Common_GetDate(new Date()))&&(DischTime>Common_GetTime(new Date()))){
						$.messager.alert("提示","标记出院时间不能晚于当前时间!",'info');
						return true;
					}
				
					if (Common_CompareDate(aAdmDate,DischDate)>0){
						$.messager.alert("提示","标记出院日期不能早于入院日期!",'info');
						return true;
					}
					if ((DischDate==aAdmDate)&&(aAdmTime>DischTime)){
						$.messager.alert("提示","标记出院时间不能早于入院时间!",'info');
						return true;
					}
	                var inputStr = obj.RecRowID;
					inputStr = inputStr + "^" + 1;
					inputStr = inputStr + "^" + DischDate;	
					inputStr = inputStr + "^" + DischTime;
					inputStr = inputStr + "^" + $.LOGON.USERID;;
		
					$m({
						ClassName:"DHCHAI.DPS.OutofbedSrv",
						MethodName:"SaveOprStatus",
						aInputStr:inputStr, 
						aSeparate:"^"
					},function(txt){
						if (txt>0) {
							$.messager.popover({msg: '标记成功！',type:'success',timeout: 1000});
							obj.RecRowID="";
							$HUI.dialog('#OprStatusEdit').close();
							obj.gridOutofBedLoad(); //刷新
						}else {
							$.messager.alert("错误提示","标记失败!",'error');
							return true;
						}
					});									
				}
			},{
				text:'关闭',
				handler:function(){$HUI.dialog('#OprStatusEdit').close();}
			}]
		});
	}
	 //显示
	obj.OprStatusEdit = function(ID,DischDate,DischTime,AdmDate,AdmTime){
		//初始清空数据
		$('#dtDischDate').datebox('setValue',DischDate);
		$('#dtDischTime').timespinner('setValue',DischTime);
		obj.RecRowID = ID;
		$('#OprStatusEdit').show();
		obj.OprStatusDialog(AdmDate,AdmTime);
	}
	
	//取消标记
	obj.CancelOpr = function(aID) {
		$.messager.confirm("取消标记", "您确定要取消本条标记记录？", function (r) {
			if (r){
				var inputStr = aID;
				inputStr = inputStr + "^" + 2;
				inputStr = inputStr + "^" + '';	
				inputStr = inputStr + "^" + '';
				inputStr = inputStr + "^" + $.LOGON.USERID;
				$m({
					ClassName:"DHCHAI.DPS.OutofbedSrv",
					MethodName:"SaveOprStatus",
					aInputStr:inputStr, 
					aSeparate:"^"
				},function(txt){
					if (txt>0) {
						$.messager.popover({msg: '取消标记成功！',type:'success',timeout: 1000});
						obj.gridOutofBedLoad(); //刷新
					}else {
						$.messager.alert("错误提示","取消标记失败!",'error');
						return true;
					}
				});			
			}
		});
	}
	//摘要信息
	obj.OpenView = function(aEpisodeID){
		var t=new Date();
		t=t.getTime();
		var strUrl = "./dhchai.ir.view.main.csp?PaadmID=" + aEpisodeID + "&PageType=WinOpen&t=" + t;
		
		//websys_createWindow样式打开[宽:95%,高：95%]
		var Width=window.screen.availWidth*0.95;
		var Height=window.screen.availHeight*0.95;
		var Top = (window.screen.availHeight - Height-30) / 2; 			//获得窗口的垂直位置 
        var Left = (window.screen.availWidth - Width-10) / 2; 			//获得窗口的水平位置
		 //--打开摘要
		var page=websys_createWindow(strUrl,"",'height='+Height+',innerHeight='+Height+',width='+Width+',innerWidth='+Width+',top='+Top+',left='+Left+',status=no,toolbar=no,menubar=no,location=no,resizable=no,scrollbars=0,titlebar=no'); 
	}
	
	//操作日期
	obj.OprStatusLog = function(aID){		
		$('#OutofBedTable').show();
		obj.gridOutofBedLogLoad(aID);
		$('#OutofBedTable').dialog({
			title:'操作日志',
			iconCls:'icon-w-edit',
			width: 650,    
			height: 450, 
			modal: true,
			isTopZindex:true,
		});		
	}
	
		
	//加载患者明细
	obj.gridOutofBedLoad = function(){
		$("#OutofBed").datagrid("loading");
		$cm ({
			ClassName:'DHCHAI.DPS.OutofbedSrv',
			QueryName:'QryOutofbed',
			ResultSetType:'array',
			aDateFrom:$("#aDateFrom").datebox('getValue'),  
			aDateTo:$("#aDateTo").datebox('getValue'),
			aHospIDs:$("#cboHosp").combobox('getValue'), 
			aLocID:$("#cboLoc").combobox('getValue'), 
			page:1,      //可选项，页码，默认1			
			rows:9999   //可选项，获取多少条数据，默认50
		},function(rs){
			$('#OutofBed').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		})
    }
	
	//加载操作明细
	obj.gridOutofBedLogLoad = function(aOutBedID){
		$("#OutofBedLog").datagrid("loading");
		$cm ({
			ClassName:'DHCHAI.DPS.OutofbedSrv',
			QueryName:'QryOutofbedLog',
			ResultSetType:'array',
			aOutBedID:aOutBedID,
			page:1,      //可选项，页码，默认1			
			rows:200    //可选项，获取多少条数据，默认50
		},function(rs){
			$('#OutofBedLog').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		})
    }
    
    
}
