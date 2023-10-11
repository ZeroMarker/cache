  //ҳ��Event
function InitCalcCostEvent(obj){

	//�¼���
	obj.LoadEvents = function(arguments){
		obj.LoadPathInfo();
		obj.LoadTbFeeSummary();
		
		// ���ò���
		$("#btnBudgetCost").on('click',function(){
			obj.HandleBudgetCost();	
		})
		
		//������¼
		$("#btnAdd").on('click',function(){
			//obj.ExpandEditPanel();
			$HUI.dialog('#winOrdBudgetRecEdit').open();
		})
		
		// �޸ļ�¼
		$("#btnEdit").on('click',function(){
			//obj.ExpandEditPanel();
			$HUI.dialog('#winOrdBudgetRecEdit').open();
			
			obj.gridFeeDetail_onEdit();
		})
		
		//ɾ����¼
		$("#btnDelete").on('click',function(){
			var selData = $('#gridFeeDetail').datagrid('getSelected');
			obj.gridFeeDeatail_onDelete(selData);
		})
		
		//ȫ��ɾ��
		$("#btnAllDel").on('click',function(){
			obj.gridFeeDetail_onAllDel();	
		})
		
		//�����¼
		$("#btnSave").on("click",function(){
			obj.SaveEditData();	
		})
	
		//��Ӽ�鲿λ
		$("#btnAddPos").on('click',function(){
			obj.AddCheckPostion();	
		})
		
		//��ѯ����ҽ��
		$("#btnSearch").on('click',function(){
			obj.SearchFormOrds();
		})
		
		//��ӹ���ҽ��������ҽ��
		$("#btnAddLeft").on('click',function(){
			obj.AddFormOrdToLeft();
		})
		
		//��ϸ/����ѡ��л������¼�������
		$HUI.tabs("#tabCalcType",{
			onSelect:function(title,index){
				if(title=="��ϸ"){
					obj.gridFeeDetail.load({
						ClassName:"DHCMA.CPW.BTS.BudgetOrdRecSrv",
						QueryName:"QryBORecCost",		
						aFormID:PathFormID,
						aHospID:CurrHosp,
						page:1,
						rows:99999
					}); 
				}else{
					$.parser.parse('#tab_summary');	
				}
			}
		})
	};
	
	//��ȡ����Ϣ
	obj.LoadPathInfo = function(){
		//��ȡ·����Ϣ
		$cm({
			ClassName:"DHCMA.CPW.BTS.PathFormSrv",
			MethodName:"GetPathInfoByForm",
			aPathFormID:PathFormID
		},function(data){
			$("#txtPathName").val(data.PathName);
			$("#txtPathType").val(data.PathType);
			$("#txtFormCost").val(data.FormCost);
			$("#txtFormDays").val(data.FormDays);	
		})
	}
	
	
	//���ػ�������
	obj.LoadTbFeeSummary = function(){
		//��ȡ��������Ϣ
		$cm({
			ClassName:"DHCMA.CPW.BTS.BudgetOrdRecSrv",
			MethodName:"GetBudgetCostInfo",
			aFormID:PathFormID
		},function(rs){
			if (rs==null ||rs==undefined) return;
			
			$("#totalCost").text(rs['TotalCost']?rs['TotalCost'].toFixed(2):"");
			$("#zfbl").text(rs["SelfPayRatio"]*100+"%");
			$("#ybylfwf").text(rs['һ��ҽ�Ʒ����']);
			$("#ybzlczf").text(rs['һ�����Ʋ�����']);
			$("#hlf").text(rs['�����']);
			$("#qtfy").text(rs['��������']);
			$("#blzdf").text(rs['������Ϸ�']);
			$("#syszdf").text(rs['ʵ������Ϸ�']);
			$("#yxxzdf").text(rs['Ӱ��ѧ��Ϸ�']);
			$("#lczdxmf").text(rs['�ٴ������Ŀ��']);
			
			//������������Ŀ��
			var sumFsszlxmfArr=[rs['������������Ŀ��'],rs['�ٴ��������Ʒ�']]
			var sumFsszlxmfVal=0;
			sumFsszlxmfArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				sumFsszlxmfVal=parseFloat(sumFsszlxmfVal)+parseFloat(item);
			})
			//$("#fsszlxmf").text(rs['������������Ŀ��']);
			$("#fsszlxmf").text(sumFsszlxmfVal!=0?sumFsszlxmfVal:"");
			
			$("#lcwlzlf").text(rs['�ٴ��������Ʒ�']);
			
			//�������Ʒ�
			var sumSszlfArr=[rs['�������Ʒ�'],rs['�����'],rs['������']]
			var sumSszlfVal=0;
			sumSszlfArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				sum1Val=parseFloat(sumSszlfVal)+parseFloat(item);
			})
			//$("#sszlf").text(rs['�������Ʒ�']);
			$("#sszlf").text(sumSszlfVal!=0?sumSszlfVal:"");
			
			$("#mzf").text(rs['�����']);
			$("#ssf").text(rs['������']);
			$("#kff").text(rs['������']);
			$("#zyzlf").text(rs['��ҽ���Ʒ�']);
			//��ҩ��
			var sumXyfArr=[rs['��ҩ��'],rs['����ҩ���']]
			var sumXyfVal=0;
			sumXyfArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				sumXyfVal=parseFloat(sumXyfVal)+parseFloat(item);
			})
			$("#xyf").text(sumXyfVal!=0?sumXyfVal:"");
			//$("#xyf").text(rs['��ҩ��']);
			$("#kjywfy").text(rs['����ҩ���']);
			$("#zchyf").text(rs['�г�ҩ��']);
			$("#zcyf").text(rs['�в�ҩ��']);
			$("#xf").text(rs['Ѫ��']);
			$("#bdblzpf").text(rs['�׵�������Ʒ��']);
			$("#qdblzpf").text(rs['�򵰰�����Ʒ��']);
			$("#nxyzlzpf").text(rs['��Ѫ��������Ʒ��']);
			$("#xbyzlzpf").text(rs['ϸ����������Ʒ��']); 
			$("#jcyycxyyhcf").text(rs['�����һ����ҽ�ò��Ϸ�']); 
			$("#zlyycxyyhcf").text(rs['������һ����ҽ�ò��Ϸ�']); 
			$("#ssyycxyyhcf").text(rs['������һ����ҽ�ò��Ϸ�']);
			$("#qtf").text(rs['������']);
			
			// ҽ�Ʒ��������
			var ylfwsrArr=[rs['һ��ҽ�Ʒ����'],rs['һ�����Ʋ�����'],rs['�����'],rs['��������'],rs['������������Ŀ��'],rs['�ٴ��������Ʒ�'],rs['�������Ʒ�'],rs['�����'],rs['������'],rs['������'],rs['��ҽ���Ʒ�']]
			var ylfwsrVal=0;
			ylfwsrArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				ylfwsrVal=parseFloat(ylfwsrVal)+parseFloat(item);
			})
			$("#ylfwsr").text(ylfwsrVal!=0?ylfwsrVal.toFixed(2):"");
			$("#ylfwsrzb").text(obj.TransPctVal(ylfwsrVal,rs['TotalCost']));
			
			//�������
			var jcsrArr=[rs['������Ϸ�'],rs['Ӱ��ѧ��Ϸ�'],rs['�ٴ������Ŀ��']]
			var jcsrVal=0;
			jcsrArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				jcsrVal=parseFloat(jcsrVal)+parseFloat(item);
			})
			$("#jcsr").text(jcsrVal!=0?jcsrVal.toFixed(2):"");
			$("#jcsrzb").text(obj.TransPctVal(jcsrVal,rs['TotalCost']));
			
			//��������
			$("#hysr").text(rs['ʵ������Ϸ�']?rs['ʵ������Ϸ�'].toFixed(2):"");
			$("#hysrzb").text(obj.TransPctVal(rs['ʵ������Ϸ�'],rs['TotalCost']));
			
			//ҩƷ�Ĳ�����
			yphcsrArr=[rs['��ҩ��'],rs['����ҩ���'],rs['�г�ҩ��'],rs['�в�ҩ��'],rs['�����һ����ҽ�ò��Ϸ�'],rs['������һ����ҽ�ò��Ϸ�'],rs['������һ����ҽ�ò��Ϸ�']]
			var yphcsrVal=0;
			yphcsrArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				yphcsrVal=parseFloat(yphcsrVal)+parseFloat(item);
			})
			$("#yphcsr").text(yphcsrVal!=0?yphcsrVal.toFixed(2):"");
			$("#yphcsrzb").text(obj.TransPctVal(yphcsrVal,rs['TotalCost']));
			
			//ҩƷѪҺ����
			ypxysrArr=[rs['��ҩ��'],rs['����ҩ���'],rs['�г�ҩ��'],rs['�в�ҩ��'],rs['Ѫ��'],rs['�׵�������Ʒ��'],rs['�򵰰�����Ʒ��'],rs['��Ѫ��������Ʒ��'],rs['ϸ����������Ʒ��']]
			var ypxysrVal=0;
			ypxysrArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				ypxysrVal=parseFloat(ypxysrVal)+parseFloat(item);
			})
			$("#ypxysr").text(ypxysrVal!=0?ypxysrVal.toFixed(2):"");
			$("#ypxysrzb").text(obj.TransPctVal(ypxysrVal,rs['TotalCost']));
			
			//�Ĳ�����
			hcsrArr=[rs['�����һ����ҽ�ò��Ϸ�'],rs['������һ����ҽ�ò��Ϸ�'],rs['������һ����ҽ�ò��Ϸ�']]
			var hcsrVal=0;
			hcsrArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				hcsrVal=parseFloat(hcsrVal)+parseFloat(item);
			})
			$("#hcsr").text(hcsrVal!=0?hcsrVal.toFixed(2):"");
			$("#hcsrzb").text(obj.TransPctVal(hcsrVal,rs['TotalCost']));
			
			//��������
			$("#qtsr").text(rs['������']?rs['������'].toFixed(2):"");
			$("#qtsrzb").text(obj.TransPctVal(rs['������'],rs['TotalCost']));
			
			//ҽ�������
			yjlsrArr=[rs['������Ϸ�'],rs['ʵ������Ϸ�'],rs['Ӱ��ѧ��Ϸ�']]
			var yjlsrVal=0;
			yjlsrArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				yjlsrVal=parseFloat(yjlsrVal)+parseFloat(item);
			})
			$("#yjlsr").text(yjlsrVal!=0?yjlsrVal.toFixed(2):"");
			$("#yjlsrzb").text(obj.TransPctVal(yjlsrVal,rs['TotalCost']));
			
			//�ɱ������
			cblsrArr=[rs['��ҩ��'],rs['����ҩ���'],rs['�г�ҩ��'],rs['�в�ҩ��'],rs['Ѫ��'],rs['�׵�������Ʒ��'],rs['�򵰰�����Ʒ��'],rs['��Ѫ��������Ʒ��'],rs['ϸ����������Ʒ��'],rs['�����һ����ҽ�ò��Ϸ�'],rs['������һ����ҽ�ò��Ϸ�'],rs['������һ����ҽ�ò��Ϸ�'],rs['������']]
			var cblsrVal=0;
			cblsrArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				cblsrVal=parseFloat(cblsrVal)+parseFloat(item);
			})
			$("#cblsr").text(cblsrVal!=0?cblsrVal.toFixed(2):"");
			$("#cblsrzb").text(obj.TransPctVal(cblsrVal,rs['TotalCost']));
			
			//���������
			zllsrArr=[rs['һ�����Ʋ�����'],rs['������������Ŀ��'],rs['�ٴ��������Ʒ�'],rs['������'],rs['��ҽ���Ʒ�']]
			var zllsrVal=0;
			zllsrArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				zllsrVal=parseFloat(zllsrVal)+parseFloat(item);
			})
			$("#zllsr").text(zllsrVal!=0?zllsrVal.toFixed(2):"");
			$("#zllsrzb").text(obj.TransPctVal(zllsrVal,rs['TotalCost']));
		})	
	}
	
	//����ռ��
	obj.TransPctVal = function(val1,val2){
		if (val1==undefined || val1=="" || val2=="" || val2==undefined || val2==0) return;
		var val=(val1/val2).toFixed(4);		//ȡ��λ��������
		var str=Number(val*100).toFixed(2);
    	str+="%";
    	return str	
	}
	
	//���ò����¼�
	obj.HandleBudgetCost = function(){
		
		var rowsLen=$("#gridFeeDetail").datagrid('getData').rows.length;
		if (rowsLen<=0){
			$.messager.alert("��ʾ","�������Ҫ�����ҽ�����ٵ��������","info");
			return;	
		}
		
		$cm({
			ClassName:"DHCMA.CPW.BTS.BudgetOrdRecSrv",
			MethodName:"BudgetFormCost",
			aFormID:PathFormID,
			aHospID:CurrHosp,
			aUserID:session['DHCMA.USERID']
		},function(ret){
			if (parseInt(ret)>0){
				obj.gridFeeDetail.load({
					ClassName:"DHCMA.CPW.BTS.BudgetOrdRecSrv",
					QueryName:"QryBORecCost",		
					aFormID:PathFormID,
					aHospID:CurrHosp,
					page:1,
					rows:99999
				});
				obj.LoadTbFeeSummary();
				$.messager.alert("��ʾ","����ɹ���","success");
			}else{
				$.messager.alert("��ʾ","����ʧ�ܣ����Ժ����ԣ�","error");	
			}	
			return;
		})
	}
	
	//��¼ѡ���¼�����
	obj.gridFeeDetail_onSelect = function(){
		var rowData = obj.gridFeeDetail.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		//console.log(rowData);
		if (rowData["BORecID"] == obj.RecRowID) {
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnAllDel").linkbutton("enable");
			obj.RecRowID="";
			obj.gridFeeDetail.clearSelections();
			obj.clearEditData();
		}else {
			obj.RecRowID = rowData["BORecID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			$("#btnAllDel").linkbutton("disable");
		}		
	}
	
	//ҽ����lookupѡ���¼�
	obj.OrdMast_onSelect=function(rowData){
		//ȡҽ���������Ϣ��ֵ
		//691||1^R^1^1^17^֧^63^1��^4^Qd^4^ע��^46^ע�����޾���ĩ^632^ע���ð���������^[40mg]^17^֧^ע���ð���������[����][40mg]
		var rstData = $cm({ClassName:"DHCMA.CPW.BTS.LinkArcimSrv",MethodName:"GetArcimInfoById",aArcimID:rowData.ArcimID,aHospID:CurrHosp,dataType:'text'},false);
		var rstArr = rstData.split("^");
		
		$('#cboOrdUOM').combobox('reload'); 
		$("#txtOrdDoseQty").val(rstArr[3]);  //����
		$('#cboOrdUOM').combobox('setValue',rstArr[4]);
		$('#cboOrdUOM').combobox('setText',rstArr[5]);
		$("#cboOrdDurat").lookup("setValue",rstArr[6]);
		$("#cboOrdDurat").lookup("setText",rstArr[7]);
		$("#cboOrdFreq").lookup("setValue",rstArr[8]);
		$("#cboOrdFreq").lookup("setText",rstArr[9]);
		$("#cboOrdInstruc").lookup("setValue",rstArr[10]);
		$("#cboOrdInstruc").lookup("setText",rstArr[11]);
		$("#txtOrdGeneID").val(rstArr[14]);
		$("#cboOrdQtyUOM").combobox("setValue",rstArr[17]);
		$("#cboOrdQtyUOM").combobox("setText",rstArr[18]); //������λ dsp
		obj.ARCICOrderType=rstArr[20];	//ҽ������
		
	};
	
	//ҽ����¼�޸ĸ�ֵ�¼�
	obj.gridFeeDetail_onEdit = function(){
		
		var selData = $('#gridFeeDetail').datagrid('getSelected');
		if (selData==undefined || selData==""){
			$.messager.alert("��ʾ","����ѡ��Ҫ�޸ĵļ�¼","info");
			return;	
		}
		
		//console.log(selData);
		$("#cboFormEp").combobox("select",selData.FormEpID);
		$("#cboOrdItem").combobox("select",selData.FormItemID);
		$("#cboPriority").combobox("select",selData.OrdPriorityID);
		$("#txtOrdMast").lookup("setValue",selData.OrdMastID);
		$("#txtOrdMast").lookup("setText",selData.OrdMastDesc);
		$("#txtOrdGeneID").val(selData.OrdGeneID);
		
		$('#cboOrdUOM').combobox('reload');
		$("#txtOrdDoseQty").val(selData.OrdDoseQty);
		$("#cboOrdUOM").combobox("setValue",selData.OrdUOMID);
		$("#cboOrdUOM").combobox("setText",selData.OrdUOMDesc);

		$("#cboOrdFreq").lookup("setValue",selData.OrdFreqID);
		$("#cboOrdFreq").lookup("setText",selData.OrdFreqDesc);	
		
		$("#cboOrdInstruc").lookup("setValue",selData.OrdInstrucID);
		$("#cboOrdInstruc").lookup("setText",selData.OrdInstrucDesc);
		
		$("#cboOrdDurat").lookup("setValue",selData.OrdDuratID);
		$("#cboOrdDurat").lookup("setText",selData.OrdDuratDesc);
		
		$("#txtOrdUseDays").val(selData.OrdUseDays);
		$("#txtOrdQty").val(selData.OrdQty);		
		$("#cboOrdQtyUOM").combobox("setValue",selData.OrdQtyUomID);
		$("#cboOrdQtyUOM").combobox("setText",selData.OrdQtyUomDesc);
		
		$("#txtOrdPos").val(selData["OrdChkPosID"]);
		if ((selData["OrdChkPosID"]!="")&&(selData["OrdChkPosID"]!=undefined)){
			$("#txtOrdPosShow").val(selData["OrdChkPosID"].split("||")[0]);	
		}else{
			$("#txtOrdPosShow").val("");	
		}	
	}
	
	//������պ���
	obj.clearEditData = function(){
		obj.cboSelectByText("cboCategory","01");
		$("#itemOrdID").val("");
		$("#cboFormEp").combobox("clear");
		$("#cboOrdItem").combobox("clear");
		//$("#cboCategory").combobox("clear");
		$("#cboPriority").combobox("clear");
		$("#txtOrdMast").lookup("clear");
		$("#txtOrdGeneID").val("");
		$("#txtOrdDoseQty").val("");
		$("#cboOrdUOM").lookup("clear");
		$("#cboOrdFreq").lookup("clear");
		$("#cboOrdInstruc").lookup("clear");
		$("#cboOrdDurat").lookup("clear");
		$("#txtOrdUseDays").val("");
		$("#txtOrdQty").val("");
		$("#cboOrdQtyUOM").combobox("clear");
		$("#txtOrdPos").val("");
		$("#txtOrdPosShow").val("");
		
		obj.RecRowID="";
		obj.Arcim="";
		obj.SelectEpDays="";
		obj.isCNMedItem="";
	}; 
	
	//ҽ����¼ɾ���¼�
	obj.gridFeeDeatail_onDelete = function(selData){
		if(selData){
			if (selData.BORecID){
				$.messager.confirm("ȷ��","ȷ��ɾ��?",function(r){
					if(r){
						$.cm({ClassName:'DHCMA.CPW.BT.BudgetOrderRec',MethodName:'DeleteById','aId':selData.BORecID},function(data){
							//debugger;
							if(parseInt(data)<0){
								$.messager.alert("��ʾ","����ʧ�ܣ����Ժ����ԣ�","error");
								return false;
							}else{
								$.messager.alert("��ʾ","�����ɹ���","success");
								obj.gridFeeDetail.load({
									ClassName:"DHCMA.CPW.BTS.BudgetOrdRecSrv",
									QueryName:"QryBORecCost",		
									aFormID:PathFormID,
									aHospID:CurrHosp,
									page:1,
									rows:99999
								});
								$("#btnAdd").linkbutton("enable");
								$("#btnEdit").linkbutton("disable");
								$("#btnDelete").linkbutton("disable");
								obj.clearEditData();	
							}
						});
					}
				});
			}
		}
		else
		{
			$.messager.alert("��ʾ","��ѡ����Ҫɾ������Ŀ��");
			return false;
		}	
	}
	
	// ȫ��ɾ��
	obj.gridFeeDetail_onAllDel = function(){
		var retData = $('#gridFeeDetail').datagrid('getData');
		var rowLen = retData.rows.length;
		
		if (rowLen>0){
			$.messager.confirm("ȷ��","ȷ��ȫ��ɾ��?",function(r){
				if(r){
					var successNum=0,failNum=0
					for (var i=0;i<rowLen;i++){
						var selData = retData.rows[i];
						$.cm({ClassName:'DHCMA.CPW.BT.BudgetOrderRec',MethodName:'DeleteById','aId':selData.BORecID},function(data){
							if(parseInt(data)<0){
								failNum++;
							}else{
								successNum++;
							}
							if ((failNum+successNum)==rowLen){
								$.messager.alert("��ʾ","�ɹ�ɾ��"+successNum+"����ʧ��"+failNum+"����","success");
								return;
							}
						});
					}
					obj.gridFeeDetail.load({
						ClassName:"DHCMA.CPW.BTS.BudgetOrdRecSrv",
						QueryName:"QryBORecCost",		
						aFormID:PathFormID,
						aHospID:CurrHosp,
						page:1,
						rows:99999
					});					
				}
			});
		}else{
			$.messager.alert("��ʾ","û�����ݿ���ɾ����","error");
			return;	
		}
		
	}
	
	
	//�༭��Ϣ�����¼�
	obj.SaveEditData = function(){
		var selData = $('#gridFeeDetail').datagrid('getSelected');
		var ParrefID="",ChildID="",FormOrderID=""
		if (selData!=null && selData!==undefined){
			var ParrefID=selData.BORecID.split("||")[0];
			var ChildID=selData.BORecID.split("||")[1];
			var FormOrderID=selData.FormOrderID
		}else{
			var ParrefID=obj.BudgetCostID
			var ChildID=""	
		}
		
		var FormEpID = $("#cboFormEp").combobox("getValue");
		var FormItemID = $("#cboOrdItem").combobox("getValue");
		var OrdCategoryID = $("#cboCategory").combobox("getValue");
		var OrdPriorityID = $("#cboPriority").combobox("getValue");
		var OrdMastID = $("#txtOrdMast").lookup("getValue");
		var OrdGeneID = $("#txtOrdGeneID").val();
		var OrdDoseQty = $("#txtOrdDoseQty").val();
		var OrdDoseUOMID = $("#cboOrdUOM").combobox("getValue");
		var OrdFreqID = $("#cboOrdFreq").lookup("getValue");
		var OrdInstrucID = $("#cboOrdInstruc").lookup("getValue");
		var OrdDuratID = $("#cboOrdDurat").lookup("getValue");
		var OrdUseDays = $("#txtOrdUseDays").val();
		var OrdQty = $("#txtOrdQty").val();
		var OrdQtyUOMID = $("#cboOrdQtyUOM").combobox("getValue");
		var OrdChkPosID = $("#txtOrdPos").val();
		
		if(OrdMastID=="")
		{
			$.messager.popover({msg: 'ҽ�����Ʋ�����Ϊ�գ�',type:'error'});
			return false;
		}
		if(OrdPriorityID=="")
		{
			$.messager.popover({msg: 'ҽ�����Ͳ�����Ϊ�գ�',type:'error'});
			return false;
		}
		if(OrdCategoryID=="")
		{
			$.messager.popover({msg: '�����ǲ�����Ϊ�գ�',type:'error'});
			return false;
		}
		if((obj.ARCICOrderType=="L")||(obj.ARCICOrderType=="X"))	//���顢���ҽ��
		{
			var PriorityDesc=$("#cboPriority").combobox("getText");
			if(PriorityDesc!="��ʱҽ��") {
				$.messager.alert("��ʾ","�������ҽ��ֻ������ʱҽ����");
				return false;
			}
		}
		
		var InputStr = ParrefID+"^"+ChildID;
		InputStr += "^" + FormEpID;
		InputStr += "^" + FormItemID;
		InputStr += "^" + FormOrderID;
		InputStr += "^" + OrdCategoryID;
		InputStr += "^" + OrdMastID;
		InputStr += "^" + OrdGeneID;
		InputStr += "^" + OrdPriorityID;
		InputStr += "^" + OrdDoseQty;
		InputStr += "^" + OrdDoseUOMID;
		InputStr += "^" + OrdFreqID;
		InputStr += "^" + OrdDuratID;
		InputStr += "^" + OrdInstrucID;
		InputStr += "^" + OrdUseDays;
		InputStr += "^" + OrdQty;
		InputStr += "^" + OrdQtyUOMID;		
		InputStr += "^" + "";
		InputStr += "^" + OrdChkPosID;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + "1";
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + session['DHCMA.USERID'];
		
		//ͬ������			
		var retData=$m({
			ClassName:"DHCMA.CPW.BT.BudgetOrderRec",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
			
		if(parseInt(retData.split("||")[0])<0){
			$.messager.popover({msg: 'ʧ�ܣ�',type:'error'});
			return;
		}else{
			$.messager.popover({msg: '�ɹ���',type:'success'});	
			obj.clearEditData();
			$HUI.dialog('#winOrdBudgetRecEdit').close();
			obj.gridFeeDetail.load({
				ClassName:"DHCMA.CPW.BTS.BudgetOrdRecSrv",
				QueryName:"QryBORecCost",		
				aFormID:PathFormID,
				aHospID:CurrHosp,
				page:1,
				rows:99999
			});
			
			return;						
		}
	}	
	
	//��鲿λͼ���¼�
	obj.AddCheckPostion = function(){
		var OrdMastID = $("#txtOrdMast").lookup("getValue");
		if(OrdMastID=="" || OrdMastID== undefined){
			$.messager.alert("��ʾ","����ѡ��ҽ����","info");
			return;
		}
		//�Ƿ��Ǽ��ҽ��
		var isExamOrder = $cm({
			ClassName:"DHCMA.CPW.IO.FromDoc",
			MethodName:"IsExamOrder",
			aArcimID:OrdMastID
		},false);
		if (parseInt(isExamOrder)!=1){
			$.messager.alert("��ʾ","ֻ��������ҽ����Ӳ�λ��","info");
			return;
		}
		
		//var row = $("#gridItemOrd").datagrid("getSelected");
		var path="dhcapp.appreppartwin.csp?itmmastid="+OrdMastID+"&selOrdBodyPartStr=*";
		if($("#txtOrdPos").val()){
			var path="dhcapp.appreppartwin.csp?itmmastid="+OrdMastID+"&selOrdBodyPartStr=" + $("#txtOrdPos").val().split("||")[1]+"*"+$("#txtOrdPos").val().split("||")[2];
		}
		websys_showModal({
			url		:path,
			title	:'��Ӽ�鲿λ',
			iconCls	:'icon-w-import',  
			closable:true,
			width	:1200,
			height	:500,
			originWindow:window,
			CallBackFunc:function(ret){
				if((ret!="")&&(ret!=undefined)){
					var arrPos=ret.split("^")
					var strPos=arrPos[0]+"||"+arrPos[1]+"||"+arrPos[2];
					$("#txtOrdPos").val(strPos);
					$("#txtOrdPosShow").val(arrPos[0]);
				}
			}
		})	
	}
	
	//��ѯ������ҽ��
	obj.SearchFormOrds = function(){
		var FormEpID=$("#cboFormEp2").combobox("getValue");
		var FormEpItemID=$("#cboOrdItem2").combobox("getValue");
		if (!FormEpID && !FormEpItemID){
			$.messager.alert("��ʾ","����ѡ�������׶�!","info");
			return;	
		}
		$cm({
			ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryPathFormEpItemOrdAll",
			aPathFormEpDr:$("#cboFormEp2").combobox("getValue"),
			aPathFormEpItemDr:$("#cboOrdItem2").combobox("getValue"),
			aHospID:CurrHosp,
			page:1,
			rows:99999
		},function(rs){
			$('#gridFormOrd').datagrid('loadData', rs);	
		})
	}
	
	//��ӹ�ѡ�Ĺ���ҽ�������
	obj.AddFormOrdToLeft = function(){
		var arrChkRows = $('#gridFormOrd').datagrid('getChecked');
		if (arrChkRows.length==0){
			$.messager.alert("��ʾ","�빴ѡҪ��ӵ�ҽ���","info");
			return	
		}
		var strFormOrdID="";
		for(var i=0;i<arrChkRows.length;i++){
			var FormOrdID=arrChkRows[i].xID;
			if (strFormOrdID=="") strFormOrdID=FormOrdID
			else strFormOrdID=strFormOrdID+"^"+FormOrdID	
		}
		
		$m({
			ClassName:"DHCMA.CPW.BTS.BudgetOrdRecSrv",
			MethodName:"SyncFormOrdToBORec",
			aFormID:PathFormID,
			aFormOrdIDStr:strFormOrdID
		},function(ret){
			if (parseInt(ret)>0){
				$.messager.alert("��ʾ","�ɹ����"+ret+"����¼","success");
				obj.gridFeeDetail.load({
					ClassName:"DHCMA.CPW.BTS.BudgetOrdRecSrv",
					QueryName:"QryBORecCost",		
					aFormID:PathFormID,
					aHospID:CurrHosp,
					page:1,
					rows:99999
				});
			}else{
				$.messager.alert("��ʾ","����ʧ�ܣ����Ժ����ԣ�","error");
			}
			
			return;	
		})
	}
	
/* 	//չ���۵����
	obj.ExpandEditPanel = function(){
		var e_width=$("#layDetail").layout("panel", "east")[0].clientWidth;
		if (e_width==0) $('#layDetail').layout('expand','east');	
	} */
	
}

