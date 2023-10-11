function InitActScreenEvent(obj) {
	obj.LoadEvent = function(){
		$('#btnQuery').on("click", function(){
			obj.btnQuery_click(); 
		});
		$('#btnReport').on("click", function(){
			obj.OpenReport_Click('',''); 
		});
		
	}
	obj.btnQuery_click=function(RepID,LocID){
		var errStr = "";					
		if ($("#DateFrom").datebox('getValue')=="") {
			errStr += "请选择开始时间!<br>";		
		}
		if ($("#DateTo").datebox('getValue')=="") {
			errStr += "请选择结束时间!<br>";	
		}
		if(errStr != "") {
			$.messager.alert("提示", errStr, 'error');
			return false;
		}
	
		var Status=Common_RadioLabel('status');
		if(Status=="非暴发"){Status=2}
		if(Status=="暴发"){Status=1}
		var IsActive =$("#ActRep").checkbox('getValue');
		IsActive = (IsActive==true? 1: 0);
		if(IsActive==1){Status=1}
		$('#gridReport').datagrid('load',{
		   ClassName:'DHCHAI.IRS.CCWarningRepSrv',
	       QueryName:'QryFindRepByLoc',
	       aHospIDs:$("#cboHospitalRep").combobox('getValue'),
	       aLocID:$("#cboLocation").combobox('getValue'),
	       aStatus:Status,
	       IsActive:IsActive,
	       aDateFrom:$("#DateFrom").datebox('getValue'),
	       aDateTo:$("#DateTo").datebox('getValue')
		});
	}
	obj.OpenReport_Click=function(RepID,LocID){
		var Item = $m({
			ClassName:"DHCHAI.IR.CCWarningRep",
			MethodName:"GetWarnItemById",
			aId:RepID
		},false);
		if (!Item) Item="主动报告";
		var url='./dhcma.hai.ir.ccwarningrep.csp?LocID=' + LocID+'&ReportID='+RepID;
		websys_showModal({
			url:url,
			title:'医院感染暴发报告:'+Item,
			iconCls:'icon-w-epr',
			width:1320,
			height:'95%',
			closable:true,
			onBeforeClose:function(){ //关闭窗口时调用查询方法实现状态更新
				obj.btnQuery_click();
			}
		});	
	}

	//预警患者
	obj.ShowPatInfo=function(LocID,WarnDate,WarnItem,SelItem){
		if (SelItem.indexOf(":")>0) {		
			SelItem=SelItem.split(":")[1];
		}
		var url='./dhcma.hai.ir.ccwarningpat.csp?WarnLocID='+LocID+'&WarnDate='+WarnDate+'&WarnItems='+WarnItem+'&SelItem='+SelItem+'&HideBtn=1';;
		websys_showModal({
			url:url,
			title:'预警患者明细',
			iconCls:'icon-w-epr',
			width:'95%',
			height:'95%'
		});	
	}
		//病区详情
		obj.ShowWardInfo=function(LocID,LocDesc){
			var url='./dhchai.hai.ir.inf.warddetails.csp?aLocDr='+LocID+'&LocDesc='+LocDesc;;
			websys_showModal({
				url:url,
				title:'病区详情',
				iconCls:'icon-w-epr',
				width:1320,
				height:'95%'
			});	
		}
		
	obj.Outbreak = function(LocID,qryWarnDate,selItems,qryWarnItems){
		if (selItems.indexOf(":")>0) {		
			selItems=selItems.split(":")[1];
		}
		$.messager.confirm("提示", selItems+"已处置为“散发”，是否确定重新处置为“暴发”，并填报感染暴发报告？", function (r) {
			if (r) {				
				var url='./dhcma.hai.ir.ccwarningrep.csp?LocID=' + LocID+'&ReportID='+""+'&QryDate='+qryWarnDate+'&SelItems='+selItems+'&WarnItems='+qryWarnItems;
				websys_showModal({
					url:url,
					title:'医院感染暴发报告:'+selItems,
					iconCls:'icon-w-epr',
					width:1320,
					height:'90%',
					onBeforeClose:function(){ //关闭窗口时调用查询方法实现状态更新
						obj.btnQuery_click()
					}
				});	
			} 
		});	
	}
			
	obj.NOutbreak = function(LocID,qryWarnDate,selItems,qryWarnItems){
		if (selItems.indexOf(":")>0) {		
			selItems=selItems.split(":")[1];
		}
		$.messager.confirm("提示", selItems+"已处置为“暴发”并填报感染暴发报告，是否确定处置为“散发”？", function (r) {
			if (r) {		
				$('#DelOpnDialog').show();
				obj.DelOpnDialog = $HUI.dialog('#DelOpnDialog',{
					title:'请输入非暴发原因',
					iconCls:'icon-w-cancel',  
					resizable:true,
					modal: true,
					isTopZindex:true,
					buttons:[{
						text:'确定',
						handler:function(){
							var Opinion =  $.trim($('#txtOpinion').val());
							if (!Opinion) {
								$.messager.alert("提示", "请输入非暴发原因!", 'info');
								return;
							}
							var InputStr = "";
							InputStr += "^" + LocID;
							InputStr += "^" + selItems;
							InputStr += "^" + qryWarnDate;
							InputStr += "^" + "2"; 
							InputStr += "^" + "";      // 处置日期
							InputStr += "^" + "";      // 处置时间
							InputStr += "^" + $.LOGON.USERID; // 处置人
							InputStr += "^" + Opinion;     // 处置意见
							InputStr += "^" + "";     // 报告ID
							InputStr += "^#" + qryWarnItems;	//查询条件
							var retval = $m({
								ClassName:"DHCHAI.IR.CCWarningAct",
								MethodName:"Update",
								aInput:InputStr,
								aSeparate:"^"
							},false);
							if (parseInt(retval)>0){
								$.messager.popover({msg: '【散发】处置成功！',type:'success',timeout: 1000});
							} else {
								$.messager.popover({msg: '【散发】处置失败！',type:'error',timeout: 1000});
							}
							$HUI.dialog('#DelOpnDialog').close();
							obj.btnQuery_click();												
						}				
					}]
				});
			}
		});		
	}
			
	obj.Delete = function(xID){
		$.messager.confirm("提示", "是否删除选中数据?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.CCWarningAct",
					MethodName:"DeleteById",
					aId:xID
				},false);	
				if (parseInt(flg) < 0) {
					$.messager.alert('删除失败!','info');
					return;
				}else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.btnQuery_click()
				}
			} 
		});
	}
	
}

