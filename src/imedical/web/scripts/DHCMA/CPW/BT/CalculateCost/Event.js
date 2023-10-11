  //页面Event
function InitCalcCostEvent(obj){

	//事件绑定
	obj.LoadEvents = function(arguments){
		obj.LoadPathInfo();
		obj.LoadTbFeeSummary();
		
		// 费用测算
		$("#btnBudgetCost").on('click',function(){
			obj.HandleBudgetCost();	
		})
		
		//新增记录
		$("#btnAdd").on('click',function(){
			//obj.ExpandEditPanel();
			$HUI.dialog('#winOrdBudgetRecEdit').open();
		})
		
		// 修改记录
		$("#btnEdit").on('click',function(){
			//obj.ExpandEditPanel();
			$HUI.dialog('#winOrdBudgetRecEdit').open();
			
			obj.gridFeeDetail_onEdit();
		})
		
		//删除记录
		$("#btnDelete").on('click',function(){
			var selData = $('#gridFeeDetail').datagrid('getSelected');
			obj.gridFeeDeatail_onDelete(selData);
		})
		
		//全部删除
		$("#btnAllDel").on('click',function(){
			obj.gridFeeDetail_onAllDel();	
		})
		
		//保存记录
		$("#btnSave").on("click",function(){
			obj.SaveEditData();	
		})
	
		//添加检查部位
		$("#btnAddPos").on('click',function(){
			obj.AddCheckPostion();	
		})
		
		//查询关联医嘱
		$("#btnSearch").on('click',function(){
			obj.SearchFormOrds();
		})
		
		//添加关联医嘱到测算医嘱
		$("#btnAddLeft").on('click',function(){
			obj.AddFormOrdToLeft();
		})
		
		//明细/汇总选项卡切换后重新加载数据
		$HUI.tabs("#tabCalcType",{
			onSelect:function(title,index){
				if(title=="明细"){
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
	
	//获取表单信息
	obj.LoadPathInfo = function(){
		//获取路径信息
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
	
	
	//加载汇总数据
	obj.LoadTbFeeSummary = function(){
		//获取表单费用信息
		$cm({
			ClassName:"DHCMA.CPW.BTS.BudgetOrdRecSrv",
			MethodName:"GetBudgetCostInfo",
			aFormID:PathFormID
		},function(rs){
			if (rs==null ||rs==undefined) return;
			
			$("#totalCost").text(rs['TotalCost']?rs['TotalCost'].toFixed(2):"");
			$("#zfbl").text(rs["SelfPayRatio"]*100+"%");
			$("#ybylfwf").text(rs['一般医疗服务费']);
			$("#ybzlczf").text(rs['一般治疗操作费']);
			$("#hlf").text(rs['护理费']);
			$("#qtfy").text(rs['其他费用']);
			$("#blzdf").text(rs['病理诊断费']);
			$("#syszdf").text(rs['实验室诊断费']);
			$("#yxxzdf").text(rs['影像学诊断费']);
			$("#lczdxmf").text(rs['临床诊断项目费']);
			
			//非手术治疗项目费
			var sumFsszlxmfArr=[rs['非手术治疗项目费'],rs['临床物理治疗费']]
			var sumFsszlxmfVal=0;
			sumFsszlxmfArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				sumFsszlxmfVal=parseFloat(sumFsszlxmfVal)+parseFloat(item);
			})
			//$("#fsszlxmf").text(rs['非手术治疗项目费']);
			$("#fsszlxmf").text(sumFsszlxmfVal!=0?sumFsszlxmfVal:"");
			
			$("#lcwlzlf").text(rs['临床物理治疗费']);
			
			//手术治疗费
			var sumSszlfArr=[rs['手术治疗费'],rs['麻醉费'],rs['手术费']]
			var sumSszlfVal=0;
			sumSszlfArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				sum1Val=parseFloat(sumSszlfVal)+parseFloat(item);
			})
			//$("#sszlf").text(rs['手术治疗费']);
			$("#sszlf").text(sumSszlfVal!=0?sumSszlfVal:"");
			
			$("#mzf").text(rs['麻醉费']);
			$("#ssf").text(rs['手术费']);
			$("#kff").text(rs['康复费']);
			$("#zyzlf").text(rs['中医治疗费']);
			//西药费
			var sumXyfArr=[rs['西药费'],rs['抗菌药物费']]
			var sumXyfVal=0;
			sumXyfArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				sumXyfVal=parseFloat(sumXyfVal)+parseFloat(item);
			})
			$("#xyf").text(sumXyfVal!=0?sumXyfVal:"");
			//$("#xyf").text(rs['西药费']);
			$("#kjywfy").text(rs['抗菌药物费']);
			$("#zchyf").text(rs['中成药费']);
			$("#zcyf").text(rs['中草药费']);
			$("#xf").text(rs['血费']);
			$("#bdblzpf").text(rs['白蛋白类制品费']);
			$("#qdblzpf").text(rs['球蛋白类制品费']);
			$("#nxyzlzpf").text(rs['凝血因子类制品费']);
			$("#xbyzlzpf").text(rs['细胞因子类制品费']); 
			$("#jcyycxyyhcf").text(rs['检查用一次性医用材料费']); 
			$("#zlyycxyyhcf").text(rs['治疗用一次性医用材料费']); 
			$("#ssyycxyyhcf").text(rs['手术用一次性医用材料费']);
			$("#qtf").text(rs['其他费']);
			
			// 医疗服务收入费
			var ylfwsrArr=[rs['一般医疗服务费'],rs['一般治疗操作费'],rs['护理费'],rs['其他费用'],rs['非手术治疗项目费'],rs['临床物理治疗费'],rs['手术治疗费'],rs['麻醉费'],rs['手术费'],rs['康复费'],rs['中医治疗费']]
			var ylfwsrVal=0;
			ylfwsrArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				ylfwsrVal=parseFloat(ylfwsrVal)+parseFloat(item);
			})
			$("#ylfwsr").text(ylfwsrVal!=0?ylfwsrVal.toFixed(2):"");
			$("#ylfwsrzb").text(obj.TransPctVal(ylfwsrVal,rs['TotalCost']));
			
			//检查收入
			var jcsrArr=[rs['病理诊断费'],rs['影像学诊断费'],rs['临床诊断项目费']]
			var jcsrVal=0;
			jcsrArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				jcsrVal=parseFloat(jcsrVal)+parseFloat(item);
			})
			$("#jcsr").text(jcsrVal!=0?jcsrVal.toFixed(2):"");
			$("#jcsrzb").text(obj.TransPctVal(jcsrVal,rs['TotalCost']));
			
			//化验收入
			$("#hysr").text(rs['实验室诊断费']?rs['实验室诊断费'].toFixed(2):"");
			$("#hysrzb").text(obj.TransPctVal(rs['实验室诊断费'],rs['TotalCost']));
			
			//药品耗材收入
			yphcsrArr=[rs['西药费'],rs['抗菌药物费'],rs['中成药费'],rs['中草药费'],rs['检查用一次性医用材料费'],rs['治疗用一次性医用材料费'],rs['手术用一次性医用材料费']]
			var yphcsrVal=0;
			yphcsrArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				yphcsrVal=parseFloat(yphcsrVal)+parseFloat(item);
			})
			$("#yphcsr").text(yphcsrVal!=0?yphcsrVal.toFixed(2):"");
			$("#yphcsrzb").text(obj.TransPctVal(yphcsrVal,rs['TotalCost']));
			
			//药品血液收入
			ypxysrArr=[rs['西药费'],rs['抗菌药物费'],rs['中成药费'],rs['中草药费'],rs['血费'],rs['白蛋白类制品费'],rs['球蛋白类制品费'],rs['凝血因子类制品费'],rs['细胞因子类制品费']]
			var ypxysrVal=0;
			ypxysrArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				ypxysrVal=parseFloat(ypxysrVal)+parseFloat(item);
			})
			$("#ypxysr").text(ypxysrVal!=0?ypxysrVal.toFixed(2):"");
			$("#ypxysrzb").text(obj.TransPctVal(ypxysrVal,rs['TotalCost']));
			
			//耗材收入
			hcsrArr=[rs['检查用一次性医用材料费'],rs['治疗用一次性医用材料费'],rs['手术用一次性医用材料费']]
			var hcsrVal=0;
			hcsrArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				hcsrVal=parseFloat(hcsrVal)+parseFloat(item);
			})
			$("#hcsr").text(hcsrVal!=0?hcsrVal.toFixed(2):"");
			$("#hcsrzb").text(obj.TransPctVal(hcsrVal,rs['TotalCost']));
			
			//其他收入
			$("#qtsr").text(rs['其他费']?rs['其他费'].toFixed(2):"");
			$("#qtsrzb").text(obj.TransPctVal(rs['其他费'],rs['TotalCost']));
			
			//医技类费用
			yjlsrArr=[rs['病理诊断费'],rs['实验室诊断费'],rs['影像学诊断费']]
			var yjlsrVal=0;
			yjlsrArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				yjlsrVal=parseFloat(yjlsrVal)+parseFloat(item);
			})
			$("#yjlsr").text(yjlsrVal!=0?yjlsrVal.toFixed(2):"");
			$("#yjlsrzb").text(obj.TransPctVal(yjlsrVal,rs['TotalCost']));
			
			//成本类费用
			cblsrArr=[rs['西药费'],rs['抗菌药物费'],rs['中成药费'],rs['中草药费'],rs['血费'],rs['白蛋白类制品费'],rs['球蛋白类制品费'],rs['凝血因子类制品费'],rs['细胞因子类制品费'],rs['检查用一次性医用材料费'],rs['治疗用一次性医用材料费'],rs['手术用一次性医用材料费'],rs['其他费']]
			var cblsrVal=0;
			cblsrArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				cblsrVal=parseFloat(cblsrVal)+parseFloat(item);
			})
			$("#cblsr").text(cblsrVal!=0?cblsrVal.toFixed(2):"");
			$("#cblsrzb").text(obj.TransPctVal(cblsrVal,rs['TotalCost']));
			
			//治疗类费用
			zllsrArr=[rs['一般治疗操作费'],rs['非手术治疗项目费'],rs['临床物理治疗费'],rs['康复费'],rs['中医治疗费']]
			var zllsrVal=0;
			zllsrArr.forEach(function (item) {
				if (item==""||item==undefined) item=0;
				zllsrVal=parseFloat(zllsrVal)+parseFloat(item);
			})
			$("#zllsr").text(zllsrVal!=0?zllsrVal.toFixed(2):"");
			$("#zllsrzb").text(obj.TransPctVal(zllsrVal,rs['TotalCost']));
		})	
	}
	
	//计算占比
	obj.TransPctVal = function(val1,val2){
		if (val1==undefined || val1=="" || val2=="" || val2==undefined || val2==0) return;
		var val=(val1/val2).toFixed(4);		//取四位四舍五入
		var str=Number(val*100).toFixed(2);
    	str+="%";
    	return str	
	}
	
	//费用测算事件
	obj.HandleBudgetCost = function(){
		
		var rowsLen=$("#gridFeeDetail").datagrid('getData').rows.length;
		if (rowsLen<=0){
			$.messager.alert("提示","请先添加要测算的医嘱，再点击操作！","info");
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
				$.messager.alert("提示","测算成功！","success");
			}else{
				$.messager.alert("提示","测算失败，请稍后重试！","error");	
			}	
			return;
		})
	}
	
	//记录选中事件处理
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
	
	//医嘱项lookup选中事件
	obj.OrdMast_onSelect=function(rowData){
		//取医嘱项相关信息赋值
		//691||1^R^1^1^17^支^63^1天^4^Qd^4^注射^46^注射用无菌粉末^632^注射用奥美拉唑钠^[40mg]^17^支^注射用奥美拉唑钠[利君][40mg]
		var rstData = $cm({ClassName:"DHCMA.CPW.BTS.LinkArcimSrv",MethodName:"GetArcimInfoById",aArcimID:rowData.ArcimID,aHospID:CurrHosp,dataType:'text'},false);
		var rstArr = rstData.split("^");
		
		$('#cboOrdUOM').combobox('reload'); 
		$("#txtOrdDoseQty").val(rstArr[3]);  //剂量
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
		$("#cboOrdQtyUOM").combobox("setText",rstArr[18]); //数量单位 dsp
		obj.ARCICOrderType=rstArr[20];	//医嘱类型
		
	};
	
	//医嘱记录修改赋值事件
	obj.gridFeeDetail_onEdit = function(){
		
		var selData = $('#gridFeeDetail').datagrid('getSelected');
		if (selData==undefined || selData==""){
			$.messager.alert("提示","请先选中要修改的记录","info");
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
	
	//数据清空函数
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
	
	//医嘱记录删除事件
	obj.gridFeeDeatail_onDelete = function(selData){
		if(selData){
			if (selData.BORecID){
				$.messager.confirm("确认","确定删除?",function(r){
					if(r){
						$.cm({ClassName:'DHCMA.CPW.BT.BudgetOrderRec',MethodName:'DeleteById','aId':selData.BORecID},function(data){
							//debugger;
							if(parseInt(data)<0){
								$.messager.alert("提示","操作失败，请稍后重试！","error");
								return false;
							}else{
								$.messager.alert("提示","操作成功！","success");
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
			$.messager.alert("提示","请选中需要删除的条目！");
			return false;
		}	
	}
	
	// 全部删除
	obj.gridFeeDetail_onAllDel = function(){
		var retData = $('#gridFeeDetail').datagrid('getData');
		var rowLen = retData.rows.length;
		
		if (rowLen>0){
			$.messager.confirm("确认","确定全部删除?",function(r){
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
								$.messager.alert("提示","成功删除"+successNum+"条，失败"+failNum+"条！","success");
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
			$.messager.alert("提示","没有数据可以删除！","error");
			return;	
		}
		
	}
	
	
	//编辑信息保存事件
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
			$.messager.popover({msg: '医嘱名称不可以为空！',type:'error'});
			return false;
		}
		if(OrdPriorityID=="")
		{
			$.messager.popover({msg: '医嘱类型不可以为空！',type:'error'});
			return false;
		}
		if(OrdCategoryID=="")
		{
			$.messager.popover({msg: '分类标记不可以为空！',type:'error'});
			return false;
		}
		if((obj.ARCICOrderType=="L")||(obj.ARCICOrderType=="X"))	//检验、检查医嘱
		{
			var PriorityDesc=$("#cboPriority").combobox("getText");
			if(PriorityDesc!="临时医嘱") {
				$.messager.alert("提示","检查或检验医嘱只能是临时医嘱！");
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
		
		//同步调用			
		var retData=$m({
			ClassName:"DHCMA.CPW.BT.BudgetOrderRec",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
			
		if(parseInt(retData.split("||")[0])<0){
			$.messager.popover({msg: '失败！',type:'error'});
			return;
		}else{
			$.messager.popover({msg: '成功！',type:'success'});	
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
	
	//检查部位图标事件
	obj.AddCheckPostion = function(){
		var OrdMastID = $("#txtOrdMast").lookup("getValue");
		if(OrdMastID=="" || OrdMastID== undefined){
			$.messager.alert("提示","请先选择医嘱！","info");
			return;
		}
		//是否是检查医嘱
		var isExamOrder = $cm({
			ClassName:"DHCMA.CPW.IO.FromDoc",
			MethodName:"IsExamOrder",
			aArcimID:OrdMastID
		},false);
		if (parseInt(isExamOrder)!=1){
			$.messager.alert("提示","只允许给检查医嘱添加部位！","info");
			return;
		}
		
		//var row = $("#gridItemOrd").datagrid("getSelected");
		var path="dhcapp.appreppartwin.csp?itmmastid="+OrdMastID+"&selOrdBodyPartStr=*";
		if($("#txtOrdPos").val()){
			var path="dhcapp.appreppartwin.csp?itmmastid="+OrdMastID+"&selOrdBodyPartStr=" + $("#txtOrdPos").val().split("||")[1]+"*"+$("#txtOrdPos").val().split("||")[2];
		}
		websys_showModal({
			url		:path,
			title	:'添加检查部位',
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
	
	//查询表单关联医嘱
	obj.SearchFormOrds = function(){
		var FormEpID=$("#cboFormEp2").combobox("getValue");
		var FormEpItemID=$("#cboOrdItem2").combobox("getValue");
		if (!FormEpID && !FormEpItemID){
			$.messager.alert("提示","请先选择所属阶段!","info");
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
	
	//添加勾选的关联医嘱到左侧
	obj.AddFormOrdToLeft = function(){
		var arrChkRows = $('#gridFormOrd').datagrid('getChecked');
		if (arrChkRows.length==0){
			$.messager.alert("提示","请勾选要添加的医嘱项！","info");
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
				$.messager.alert("提示","成功添加"+ret+"条记录","success");
				obj.gridFeeDetail.load({
					ClassName:"DHCMA.CPW.BTS.BudgetOrdRecSrv",
					QueryName:"QryBORecCost",		
					aFormID:PathFormID,
					aHospID:CurrHosp,
					page:1,
					rows:99999
				});
			}else{
				$.messager.alert("提示","操作失败，请稍后重试！","error");
			}
			
			return;	
		})
	}
	
/* 	//展开折叠面板
	obj.ExpandEditPanel = function(){
		var e_width=$("#layDetail").layout("panel", "east")[0].clientWidth;
		if (e_width==0) $('#layDetail').layout('expand','east');	
	} */
	
}

