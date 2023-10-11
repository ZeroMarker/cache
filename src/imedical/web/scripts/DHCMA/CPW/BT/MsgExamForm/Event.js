function InitViewFormWinEvent(obj){
	//加载事件
	obj.LoadEvents = function(arguments){		
		/* 消息处置主页面事件 */

		// 审核通过
		$("#btnPass").on('click',function(){
			if (obj.ExamResult!="-1") return;
			obj.HandleMessage("1");
		})
		
		// 审核不通过
		$("#btnNoPass").on('click',function(){
			if (obj.ExamResult!="-1") return;
			obj.HandleMessage("0");
		})
		
		/* 
		// 费用测算
		$("#imgBudgetCost").on('click',function(){
			obj.showBudgetCostDiag();	
		}) 
		*/
	
	}
	
	// 查看关联医嘱明细
	obj.ViewLnkOrds= function(id) {
		$cm ({
			ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryPathFormEpItemOrdAll",
			ResultSetType:"array",
			aPathFormEpDr:id.split('-')[1],
			aPathFormEpItemDr:"",
			aHospID:session['DHCMA.HOSPID'],
			aOrdDesc:"",
			aOrdGroupID:""
		},function(rs){
			$('#gridOrders').datagrid('loadData', rs);				
		});
		$HUI.dialog('#winViewLnkOrds').open();
	}
	
	// 处置消息
	obj.HandleMessage = function(isPass) {
		var txtOpinion = $("#txtOpinion").val();
		
		if (isPass=="0"&&txtOpinion==""){
			$.messager.alert("提示","审核不通过必须填写审核意见！","error");
			return; 	
		}
		
		//发送申请消息
		$.cm({ClassName:'DHCMA.CPW.BTS.ApplyExamRecSrv',MethodName:'HandleFormExamMsg','aFormID':PathFormID,'aExamDtlID':RecDtlID,'aIsPass':isPass,'aPriorVal':PriorNo,'aUserID':session['DHCMA.USERID'],'aOpinion':txtOpinion},function(data){
			if(parseInt(data)<0){
				$.messager.alert("提示","消息处置失败，请稍后重试！","error"); 
			}else{															
				$.messager.alert("提示","消息成功处置！","success",function(){
					window.location.reload();
				});
			}
		});	
	}
	
	/*
	//弹出费用测算窗口
	obj.showBudgetCostDiag = function(){
		//费用测算
		if(PathFormID=="" || PathFormID == undefined)
		{
			$.messager.alert("提示","无法获取当前版本，请稍后重试！","error");
			return;
		}
		else
		{
			//费用测算弹窗		
			websys_showModal({
				url:"./dhcma.cpw.bt.calculatecost.csp?1=1" +"&PathFormID=" + PathFormID +"&CurrHosp="+ session['DHCMA.HOSPID'] ,
				title:"费用测算",
				iconCls:'icon-fee',  
				closable:true,
				originWindow:window,
				width:"90%",
				height:"95%"
			})
		}	
	}
	*/
	
	// 显示路径信息页面
	obj.showPathInfoDiag = function(){
		if(PathFormID=="" || PathFormID == undefined){
			$.messager.alert("提示","无法获取当前版本，请稍后重试！","error");
			return;
		}else{
			//路径信息弹窗		
			websys_showModal({
				url:"./dhcma.cpw.bt.msgformedit.csp?1=1" +"&PathFormID=" + PathFormID +"&RecDtlID=" + RecDtlID ,
				title:"路径信息",
				iconCls:'icon-paper-info',  
				closable:true,
				originWindow:window,
				width:"90%",
				height:"95%"
			})
		}	
	}

}