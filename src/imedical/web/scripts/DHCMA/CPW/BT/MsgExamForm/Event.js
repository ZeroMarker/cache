function InitViewFormWinEvent(obj){
	//�����¼�
	obj.LoadEvents = function(arguments){		
		/* ��Ϣ������ҳ���¼� */

		// ���ͨ��
		$("#btnPass").on('click',function(){
			if (obj.ExamResult!="-1") return;
			obj.HandleMessage("1");
		})
		
		// ��˲�ͨ��
		$("#btnNoPass").on('click',function(){
			if (obj.ExamResult!="-1") return;
			obj.HandleMessage("0");
		})
		
		/* 
		// ���ò���
		$("#imgBudgetCost").on('click',function(){
			obj.showBudgetCostDiag();	
		}) 
		*/
	
	}
	
	// �鿴����ҽ����ϸ
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
	
	// ������Ϣ
	obj.HandleMessage = function(isPass) {
		var txtOpinion = $("#txtOpinion").val();
		
		if (isPass=="0"&&txtOpinion==""){
			$.messager.alert("��ʾ","��˲�ͨ��������д��������","error");
			return; 	
		}
		
		//����������Ϣ
		$.cm({ClassName:'DHCMA.CPW.BTS.ApplyExamRecSrv',MethodName:'HandleFormExamMsg','aFormID':PathFormID,'aExamDtlID':RecDtlID,'aIsPass':isPass,'aPriorVal':PriorNo,'aUserID':session['DHCMA.USERID'],'aOpinion':txtOpinion},function(data){
			if(parseInt(data)<0){
				$.messager.alert("��ʾ","��Ϣ����ʧ�ܣ����Ժ����ԣ�","error"); 
			}else{															
				$.messager.alert("��ʾ","��Ϣ�ɹ����ã�","success",function(){
					window.location.reload();
				});
			}
		});	
	}
	
	/*
	//�������ò��㴰��
	obj.showBudgetCostDiag = function(){
		//���ò���
		if(PathFormID=="" || PathFormID == undefined)
		{
			$.messager.alert("��ʾ","�޷���ȡ��ǰ�汾�����Ժ����ԣ�","error");
			return;
		}
		else
		{
			//���ò��㵯��		
			websys_showModal({
				url:"./dhcma.cpw.bt.calculatecost.csp?1=1" +"&PathFormID=" + PathFormID +"&CurrHosp="+ session['DHCMA.HOSPID'] ,
				title:"���ò���",
				iconCls:'icon-fee',  
				closable:true,
				originWindow:window,
				width:"90%",
				height:"95%"
			})
		}	
	}
	*/
	
	// ��ʾ·����Ϣҳ��
	obj.showPathInfoDiag = function(){
		if(PathFormID=="" || PathFormID == undefined){
			$.messager.alert("��ʾ","�޷���ȡ��ǰ�汾�����Ժ����ԣ�","error");
			return;
		}else{
			//·����Ϣ����		
			websys_showModal({
				url:"./dhcma.cpw.bt.msgformedit.csp?1=1" +"&PathFormID=" + PathFormID +"&RecDtlID=" + RecDtlID ,
				title:"·����Ϣ",
				iconCls:'icon-paper-info',  
				closable:true,
				originWindow:window,
				width:"90%",
				height:"95%"
			})
		}	
	}

}