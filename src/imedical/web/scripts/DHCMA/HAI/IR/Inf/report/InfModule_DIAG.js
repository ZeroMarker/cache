function InitDiag(obj){
	var oldInfDate='';
	// 感染诊断
	obj.refreshINFDiagnos = function(){
		var InfPosList=$cm({
			ClassName:"DHCHAI.BTS.InfPosSrv",
			MethodName:"GetInfPosTree"
		},false);
		
		$('#cboInfPos').combotree('loadData',InfPosList);
		$('#cboInfPos').combotree({
			autoNodeHeight:true,
			lines:true,
			editable:true,
			onChange: function(newValue, oldValue){	
				if (newValue.indexOf("||")>0){
					newValue = newValue.split("||")[0];
				}
				var InfPos = $m({
					ClassName:"DHCHAI.BT.InfPos",
					MethodName:"GetDescByID",		
					aID: newValue
				},false);
				
				var InfType  = Common_RadioValue("radInfType");
				var InfDate = $('#txtInfDate').datebox('getValue');
			    var AdmDate = obj.AdmInfo.rows[0].AdmDate;
				if ((InfPos.indexOf("手术切口")>0||InfPos.indexOf("腔隙感染")>0)) {
					$('#txtInfDate').datebox('setValue',Common_GetDate(new Date()));
					$('#cboInfLoc').lookup('enable'); //感染科室可选
					if(ReportID!=""){
						if (oldValue!="") {
							obj.LayerOpenINFOPS();
						}
					}else{
						if ((DiagnosID)&&(oldValue!="")||(!DiagnosID)) {  //疑似筛查确诊的手术相关感染默认不弹窗，修改时可弹窗
							obj.LayerOpenINFOPS();
						}
					}
				} else {
					$('#cboInfLoc').lookup('disable');
					if ((InfType==1)&&(InfDate)) {
						var TransInfo = $m({
							ClassName:"DHCHAI.DPS.PAAdmTransSrv",
							MethodName:"GetTransInfoByDate",		
							aEpisodeDr: EpisodeID,
							aDate:InfDate
						},false);
						var InfLoc =TransInfo.split("^")[0];
						var objLoc = $cm({
							ClassName:"DHCHAI.BT.Location",
							MethodName:"GetObjById",		
							aId: InfLoc
						},false);
						if (!objLoc) return;
						if (!InfLoc)  {
							$('#txtInfDate').datebox('clear');
							$.messager.alert("提示", "根据感染日期无法找到感染归属科室，请检查填写是否有误!", 'info');
							return;
						} else {
							$('#txtInfLoc').val(InfLoc);	
							$('#cboInfLoc').lookup('setText',objLoc.BTDesc);	
						}
					} else {
						$('#txtInfLoc').val('');	
						$('#cboInfLoc').lookup('setText','');	
					}
				}
				
			},keyHandler: {
           		query: function(q,e){
		            var t = $(this).combotree('tree');  
		            var nodes = t.tree('getChildren');  
		            for(var i=0; i<nodes.length; i++){ 
		                var node = nodes[i];  
		                if (node.text.indexOf(q) >= 0){ 
		                    if (node.text==q) {
			                     $(this).combotree('setValue',node.id);
		                    }
		                    $(node.target).show();
		                } else {  
		                    $(node.target).hide();  
		                }  
		            }  
		            var opts = $(this).combotree('options');  
		            if (!opts.hasSetEvents){
		                opts.hasSetEvents = true;  
		                var onShowPanel = opts.onShowPanel;  
		                opts.onShowPanel = function(){  
		                    var nodes = t.tree('getChildren');  
		                    for(var i=0; i<nodes.length; i++){  
		                        $(nodes[i].target).show(); 
		                    }  
		                    onShowPanel.call(this);  
		                };  
		                $(this).combo('options').onShowPanel = opts.onShowPanel;  
		            }
		        }
		     }
		 });
	
	
		/*
		obj.cboInfPos = $HUI.combobox("#cboInfPos", {
			editable: true,       
			defaultFilter:4,     
			valueField: 'ID',
			textField: 'Desc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCHAI.BTS.InfPosSrv&QueryName=QryInfPosToSelect&ResultSetType=array&aPosFlg=2";
			   	$("#cboInfPos").combobox('reload',url);
			},
			onChange:function(newValue,oldValue){	
				$('#cboInfSub').combobox('clear');
			},
			onSelect:function(rows){
				var InfPos = rows.Desc;
				var InfType  = Common_RadioValue("radInfType");
				var InfDate = $('#txtInfDate').datebox('getValue');
			    var AdmDate = obj.AdmInfo.rows[0].AdmDate;
				var Day = DateDiff(InfDate,AdmDate);	
				//if ((InfPos.indexOf("手术切口")>0||InfPos.indexOf("器官（或腔隙）")>0)&&(Common_CompareDate(InfDate,AdmDate)>0)&&(Day<3)) {  //手术感染，感染日期在入院前三天
				if ((InfPos.indexOf("手术切口")>0||InfPos.indexOf("或腔隙")>0)) {
					$('#cboInfLoc').lookup('enable'); //感染科室可选
					obj.IsHist="1";
					obj.LayerOpenINFOPS();
				} else {
					obj.IsHist="";
					$('#cboInfLoc').lookup('disable');
					if ((InfType==1)&&(InfDate)) {
						var TransInfo = $m({
							ClassName:"DHCHAI.DPS.PAAdmTransSrv",
							MethodName:"GetTransInfoByDate",		
							aEpisodeDr: EpisodeID,
							aDate:InfDate
						},false);
						var InfLoc =TransInfo.split("^")[0];
						var objLoc = $cm({
							ClassName:"DHCHAI.BT.Location",
							MethodName:"GetObjById",		
							aId: InfLoc
						},false);
						if (!objLoc) return;
						if (!InfLoc)  {
							$('#txtInfDate').datebox('clear');
							$.messager.alert("提示", "根据感染日期无法找到感染归属科室，请检查填写是否有误!", 'info');
							return;
						} else {
							$('#txtInfLoc').val(InfLoc);	
							$('#cboInfLoc').lookup('setText',objLoc.BTDesc);	
						}
					} else {
						$('#txtInfLoc').val('');	
						$('#cboInfLoc').lookup('setText','');	
					}
				}
			}
						
		});
		
		obj.cboInfSub = $HUI.combobox("#cboInfSub", {
			editable: false,       
			defaultFilter:4,     
			valueField: 'ID',
			textField: 'Desc',			
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCHAI.BTS.InfSubSrv&QueryName=QryInfSubByPosID&ResultSetType=array&aPosID="+$('#cboInfPos').combobox('getValue');
				$("#cboInfSub").combobox('reload',url);
			}
		});
		*/
		//感染转归字典
		obj.cboInfEffect = Common_ComboDicID("cboInfEffect","InfDiseasePrognosis");
		//与死亡关系字典
		obj.cboDeathRelation = Common_ComboDicID("cboDeathRelation","RepDeathRelative");
		
		obj.cboInfLoc = $HUI.lookup("#cboInfLoc", {
			panelWidth:300,
			url:$URL,
			editable: true,
			mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
			isValid:true,
			pagination:true,
			loadMsg:'正在查询',	
			isCombo:true,             //是否输入字符即触发事件，进行搜索
			minQueryLen:1,             //isCombo为true时，可以搜索要求的字符最小长度
			valueField: 'ID',
			textField: 'LocDesc',
			queryParams:{ClassName: 'DHCHAI.BTS.LocationSrv',QueryName: 'QryLocSrv',aHospID:$.LOGON.HOSPID,aLocCate:"I",aLocType:"E",aIsActive:1,aIsGroup:1},
			columns:[[  
				{field:'LocDesc',title:'科室名称',width:280}  
			]],
			onBeforeLoad:function(param){
				var desc=param['q'];
				param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
			},
			onSelect:function(index,rowData){  
				$('#txtInfLoc').val(rowData['ID']);			
			}
		});
		//医院感染类型
		$HUI.radio("[name='radInfType']",{  
			onChecked:function(e,value){
				var InfType = $(e.target).val();   //当前选中的值
				if (InfType==1) {
					if(oldInfDate) {	
						$('#txtInfDate').datebox('setValue',oldInfDate);
					}else {
						$('#txtInfDate').datebox('clear');
					}		
				}else {
					oldInfDate =$('#txtInfDate').datebox('getValue');
					$('#txtInfDate').datebox('setValue',obj.AdmInfo.rows[0].AdmDate);
				}
			}
		});
		
		//日期改变事件
		$('#txtInfDate').datebox({
			onChange: function(newValue, oldValue){				
				var InfDate = newValue;
				var InfType  = Common_RadioValue("radInfType");
				var InfPos = $('#cboInfPos').combotree('getText');
				var AdmDate = obj.AdmInfo.rows[0].AdmDate;		
				
				$('#cboInfLoc').lookup('disable');
				if(InfType==1) {
					if (obj.InfOperDate) {
						$('#cboInfLoc').lookup('enable');
						 return;   //手术相关类型的感染科室根据手术日期判断，不按感染日期变化
					}
					var TransInfo = $m({
						ClassName:"DHCHAI.DPS.PAAdmTransSrv",
						MethodName:"GetTransInfoByDate",		
						aEpisodeDr: EpisodeID,
						aDate:InfDate
					},false);
					var InfLoc =TransInfo.split("^")[0];
					if (InfLoc=="") return;
					var objLoc = $cm({
						ClassName:"DHCHAI.BT.Location",
						MethodName:"GetObjById",		
						aId: InfLoc
					},false);
					if (!objLoc) return;
					if (!InfLoc)  {
						$('#txtInfDate').datebox('clear');
						$.messager.alert("提示", "根据感染日期无法找到感染归属科室，请检查填写是否有误!", 'info');
						return;
					} else {
						$('#txtInfLoc').val(InfLoc);	
						$('#cboInfLoc').lookup('setText',objLoc.BTDesc);	
					}
				} else {
					$('#txtInfLoc').val('');	
					$('#cboInfLoc').lookup('setText','');	
				}
			}
		});
		
		
		
		//数据加载
		if (ReportID) {
			obj.RepDiag = $cm({
				ClassName:"DHCHAI.IRS.INFDiagnosSrv",
				QueryName:"QryINFDiagByRep",		
				aReportID: ReportID,
				aEpisodeID: EpisodeID
			},false);
		    
			if (obj.RepDiag.total>0) {
				var RepDiag = obj.RepDiag.rows[0];
				var InfType = RepDiag.InfType;
				if (!InfType) InfType=1;
				if (InfType==0) {
					$HUI.radio('#radInfType-0').setValue(true);
				}else {
					$HUI.radio('#radInfType-1').setValue(true);
				}
				if (RepDiag.InfSubID) {
					$('#cboInfPos').combotree('setValue',RepDiag.InfPosID+"||"+RepDiag.InfSubID);
					$('#cboInfPos').combotree('setText',RepDiag.InfSub);
				}else {
					$('#cboInfPos').combotree('setValue',RepDiag.InfPosID);
					$('#cboInfPos').combotree('setText',RepDiag.InfPos);
				}
				
				$('#txtInfDate').datebox('setValue',RepDiag.InfDate);
				$('#txtInfXDate').datebox('setValue',RepDiag.InfXDate);
				$('#cboInfEffect').combobox('setValue',RepDiag.InfEffectID);
				$('#cboInfEffect').combobox('setText',RepDiag.InfEffect);
				$('#cboDeathRelation').combobox('setValue',RepDiag.DeathRelationID);
				$('#cboDeathRelation').combobox('setText',RepDiag.DeathRelation);
				$('#txtDiagnosisBasis').val(RepDiag.InfDiagnosisBasis);
				$('#txtDiseaseCourse').val(RepDiag.InfDiseaseCourse);
				$('#txtInfLoc').val(RepDiag.InfLocID);	
				$('#cboInfLoc').lookup('setText',RepDiag.InfLoc);	
				
				obj.IsReportDiag = RepDiag.IsReportDiag;	// 是否临床上报诊断					
			}	
			
		}else if (DiagnosID) {
			rowData = $m({
				ClassName:"DHCHAI.IRS.INFDiagnosSrv",
				MethodName:"GetStrByRowID",
				aID:DiagnosID
			},false);
		   
			var arrData   = rowData.split("^");
			var InfPosID  = arrData[1];
			var InfPos    = arrData[2];
			var InfSubID  = arrData[3];
			var InfSub    = arrData[4];
			var InfDate   = arrData[5];
			var InfLocID  = arrData[6];
			var InfLoc    = arrData[7];
			var InfXDate  = arrData[10];
			var InfEffectID  = arrData[11];
			var InfEffect    = arrData[12];
			var DeathRelationID  = arrData[13];
			var DeathRelation    = arrData[14];
			var IsReportDiag     = arrData[15];
			var InfType          = arrData[18];
			if (!InfType) InfType=1;
		   	if (InfType==0) {
				$HUI.radio('#radInfType-0').setValue(true);
			}else {
				$HUI.radio('#radInfType-1').setValue(true);
			}
		
			if (InfSubID) {
				$('#cboInfPos').combotree('setValue',InfPosID+"||"+InfSubID);
				$('#cboInfPos').combotree('setText',InfSub);
			}else {
				$('#cboInfPos').combotree('setValue',InfPosID);
				$('#cboInfPos').combotree('setText',InfPos);
			}
				
			$('#txtInfDate').datebox('setValue',InfDate);
			$('#txtInfXDate').datebox('setValue',InfXDate);
			$('#cboInfEffect').combobox('setValue',InfEffectID);
			$('#cboInfEffect').combobox('setText',InfEffect);
			$('#cboDeathRelation').combobox('setValue',DeathRelationID);
			$('#cboDeathRelation').combobox('setText',DeathRelation);
			if ((InfLocID)&&(InfLoc)) {
				$('#txtInfLoc').val(InfLocID);
				$('#cboInfLoc').lookup('setText',InfLoc);	
			}
		    		
			obj.IsReportDiag = IsReportDiag;	// 是否临床上报诊断	
		} else{
			obj.IsReportDiag = 1;	// 是否临床上报诊断
		}
	}
	obj.refreshINFDiagnos();
	
	obj.DIAG_Save = function() {
		var errorStr = '';
		var InfType  = Common_RadioValue("radInfType");
		var InfPosSub = $('#cboInfPos').combotree('getValue');
		var InfPosID ="" ,InfSubID ="";
		if ((InfPosSub)&&(InfPosSub.indexOf("||")>0) ){
			InfPosID =InfPosSub.split("||")[0] ;
			InfSubID =InfPosSub.split("||")[1];
		}else {
			InfPosID =InfPosSub;
		}
	   
		var InfDate = $('#txtInfDate').datebox('getValue');
		var InfXDate = $('#txtInfXDate').datebox('getValue');
		var InfEffectID = $('#cboInfEffect').combobox('getValue');
		var InfEffect = $('#cboInfEffect').combobox('getText');
		var DeathRelationID = $('#cboDeathRelation').combobox('getValue');
		var InfDiagnosisBasis = $('#txtDiagnosisBasis').val();
		var InfDiseaseCourse = $('#txtDiseaseCourse').val();
		var AdmDate = obj.AdmInfo.rows[0].AdmDate;
		var DischDate = obj.AdmInfo.rows[0].DischDate;
		var NowDate = Common_GetDate(new Date());
	    var InfLoc = $('#txtInfLoc').val();	
		
		if (!InfPosID) {
			//errorStr = errorStr + "请填写感染诊断!<br>"; 
			errorStr = errorStr + $g("请填写感染诊断!")+"<br>"; 
		}
		if (!InfDate) {
			//errorStr = errorStr + "请填写感染日期!<br>"; 
			errorStr = errorStr + $g("请填写感染日期!")+"<br>"; 
		}else {
			
			if (InfType==1) {  //医院感染
				//手术部位感染不判断日期范围
				var InfPosDesc=$('#cboInfPos').combobox('getText');
				
				if ((InfPosDesc.indexOf("手术切口")>0||InfPosDesc.indexOf("腔隙感染")>0)) {
					if (!InfLoc)  {
						//errorStr = errorStr + "感染科室不能为空，请检查填写是否有误!<br>"; 
						errorStr = errorStr + $g("感染科室不能为空，请检查填写是否有误!")+"<br>";
					}
					if ((Common_CompareDate(InfDate,NowDate)>0)) {
						//errorStr = errorStr + "感染时间不应超出当前日期!<br>"; 
						errorStr = errorStr + $g("感染时间不应超出当前日期!")+"<br>"; 
					}
				} else{
					if (AdmDate==InfDate) {
						//errorStr = errorStr + "感染类型为医院感染，感染日期不能是入院第一天!<br>";
						errorStr = errorStr + $g("感染类型为医院感染，感染日期不能是入院第一天!")+"<br>";
					}
					if ((Common_CompareDate(AdmDate,InfDate)>0)||(Common_CompareDate(InfDate,DischDate)>0)||(Common_CompareDate(InfDate,NowDate)>0)) {
						//errorStr = errorStr + "感染时间需要在住院期间且不应超出当前日期!<br>"; 
						errorStr = errorStr + $g("感染时间需要在住院期间且不应超出当前日期!")+"<br>"; 
					}
					if (!InfLoc)  {
						errorStr = errorStr + $g("根据感染日期无法找到感染归属科室，请检查填写是否有误!")+"<br>"; 
					}
				}
			} else {
				var AdmDate = obj.AdmInfo.rows[0].AdmDate;		
				var Day = DateDiff(InfDate,AdmDate);
				if ((Day>=3)||(Common_CompareDate(InfDate,NowDate)>0)) {
					errorStr = errorStr +  $g("社区感染日期只能在入院前3天及之前且不应超出当前日期!")+"<br>"; 
				}
				/*
				if ((Common_CompareDate(InfDate,DischDate)>0)||(Common_CompareDate(InfDate,NowDate)>0)) {
					errorStr = errorStr + "社区感染时间需要在出院之前且不应超出当前日期!<br>"; 
				}
				*/
			}
			
		}
		if (InfXDate) {
			if (Common_CompareDate(InfDate,InfXDate)>0){
    			//errorStr = errorStr + "感染结束日期不能在感染日期之前!<br>"; 
    			errorStr = errorStr + $g("感染结束日期不能在感染日期之前!")+"<br>"; 
    		}
    		if (obj.IsHist!=1){	
				if ((Common_CompareDate(InfXDate,DischDate)>0)||(Common_CompareDate(InfXDate,NowDate)>0)) {
					//errorStr = errorStr + "感染结束日期需在住院期间且不应超出当前日期!<br>"; 
					errorStr = errorStr + $g("感染结束日期需在住院期间且不应超出当前日期!")+"<br>"; 
				}
    		}
    		if (!InfEffectID){
				//errorStr = errorStr + "感染结束后感染转归不能为空!<br>"; 
				errorStr = errorStr + $g("感染结束后感染转归不能为空!")+"<br>"; 
		    }
		} else {
			if ((InfEffect=='治愈')||(InfEffect=='死亡')||(InfEffect=='好转')){
				//errorStr = errorStr + "感染转归为治愈、死亡、好转感染结束日期不能为空!<br>"; 
				errorStr = errorStr + $g("感染转归为治愈、死亡、好转感染结束日期不能为空!")+"<br>"; 
			}
		}
		if (((InfEffect=='死亡')||(obj.AdmInfo.rows[0].IsDeath=='1'))&&(!DeathRelationID)) {
			//errorStr = errorStr + "感染转归为死亡、死亡病例，请填写感染与死亡关系!<br>"; 
			errorStr = errorStr + $g("感染转归为死亡、死亡病例，请填写感染与死亡关系!")+"<br>"; 
		}
		
		if ((ServerObj.BasisNeed==1)&&(!InfDiagnosisBasis)) {
			errorStr = errorStr + $g("请填写诊断依据!")+"<br>"; 
		}
		
		if (errorStr!="") { 
		    //errorStr=$g(errorStr);  分开翻译
			$.messager.alert("提示", errorStr, 'info');
			return; 
		}
		
		// 感染信息	
		if (ReportID) {
			obj.RepDiag = $cm({
				ClassName:"DHCHAI.IRS.INFDiagnosSrv",
				QueryName:"QryINFDiagByRep",		
				aReportID: ReportID
			},false);
		}
    	var Diags = '';
    	var ID = (obj.RepDiag ? obj.RepDiag.rows[0].ID : DiagnosID);
		var Input = ID;
		Input = Input + CHR_1 + EpisodeID;
		Input = Input + CHR_1 + InfPosID;
		Input = Input + CHR_1 + InfSubID;
		Input = Input + CHR_1 + InfDate;
		Input = Input + CHR_1 + InfLoc;
		Input = Input + CHR_1 + InfDiagnosisBasis;
		Input = Input + CHR_1 + InfDiseaseCourse;
		Input = Input + CHR_1 + InfXDate;
		Input = Input + CHR_1 + InfEffectID;
		Input = Input + CHR_1 + DeathRelationID;
		Input = Input + CHR_1 + '';
		Input = Input + CHR_1 + '';
		Input = Input + CHR_1 + $.LOGON.USERID;
		Input = Input + CHR_1 + obj.IsReportDiag;	// 是否临床上报诊断
		Input = Input + CHR_1 + '';                 // 病原体 多个#分割
		Input = Input + CHR_1 + 1;                  // 是否有效
		Input = Input + CHR_1 + InfType;            // 感染类型
		Diags = Diags + CHR_2 + Input;
      
    	if (Diags) Diags = Diags.substring(1,Diags.length);
    	return Diags;
	}
	
	//诊断依据
	obj.LayerDiagBasis = function() {
		$HUI.dialog('#LayerDiagBasis',{
			title:$g('诊断依据-选择'),
			iconCls:'icon-w-paper',
			width: 900,    
			modal: true,
			isTopZindex:true,
			buttons:[{
				text:'确认',
				handler:function(){	
					var DiagBasisList="";
					var rows = obj.gridDiagBasis.getCheckedNodes();			
					var length = obj.gridDiagBasis.getCheckedNodes().length; 
									
					for (i=0;i<length;i++) {
						var BTDesc = rows[i].BTDesc;
						if (!BTDesc) continue;
						DiagBasisList += BTDesc+" ";
					}
					var DiagBasis = $("#txtDiagnosisBasis").val(); 
					if (!DiagBasis) {
						$('#txtDiagnosisBasis').val(DiagBasisList);
					}else {
						$('#txtDiagnosisBasis').val(DiagBasis+DiagBasisList);
					}
					$HUI.dialog('#LayerDiagBasis').close();
				}
			},{
				text:'取消',
				handler:function(){$HUI.dialog('#LayerDiagBasis').close();}
			}]
		});
	}
	 obj.refreshgridDiagBasis = function(){
		obj.gridDiagBasis = $HUI.treegrid("#gridDiagBasis",{ 
			fit: true,
			//title:'诊断依据',
			headerCls:'panel-header-gray',
			iconCls:'icon-paper',
			//toolbar: [],
			pagination: false,
			rownumbers: true, //如果为true, 则显示一个行号列
			idField:'RowId',           //关键字段来标识树节点，不能重复  
			treeField:'RowDesc', //树节点字段，也就是树节点的名称
			loadMsg:'数据加载中...',
			url:$URL,
			queryParams:{
				ClassName:'DHCHAI.BTS.InfPosGistSrv',
				QueryName:'QryPosGistTree',
				aTypeCode:'',
				aInfPosID:(($('#cboInfPos').combotree('getValue').indexOf("||")>0) ? $('#cboInfPos').combotree('getValue').split("||")[0]:$('#cboInfPos').combotree('getValue'))
			},
			columns:[[
				{field:'RowDesc',title:'诊断依据',width:720},
				{field:'TypeDesc',title:'类型',width:100}
			]]
		});
    }
	
	$("#btnDiagBasis").click(function(e){
		obj.refreshgridDiagBasis();
		$('#LayerDiagBasis').show();
		obj.LayerDiagBasis();
	});
	
	//疾病病程
	obj.LayerCourse = function() {
		$HUI.dialog('#LayerDiagCourse',{	
			title:'感染性疾病病程-选择',
			iconCls:'icon-w-paper',
			width: 700,    
			modal: true,
			isTopZindex:true,
			buttons:[{
				text:'确认',
				handler:function(){	
					var DiagCourseList="";
					var rows = obj.gridDiagCourse.getChecked();			
					var length = obj.gridDiagCourse.getChecked().length;  
					for (i=0;i<length;i++) {
						var DicDesc = rows[i].DicDesc;
						DiagCourseList += DicDesc+" ";
					}
					var DiagCourse = $("#txtDiseaseCourse").val(); 
					if (!DiagCourse) {
						$('#txtDiseaseCourse').val(DiagCourseList);
					}else {
						$('#txtDiseaseCourse').val(DiagCourse+DiagCourseList);
					}
					$HUI.dialog('#LayerDiagCourse').close();
				}
			},{
				text:'取消',
				handler:function(){$HUI.dialog('#LayerDiagCourse').close();}
			}]
		});
	}
	
	 obj.refreshgridDiagCourse = function(){
		obj.gridDiagCourse = $HUI.datagrid("#gridDiagCourse",{ 
			fit: true,
			//title:'疾病病程',
			headerCls:'panel-header-gray',
			iconCls:'icon-paper',
			//toolbar: [],
			pagination: false,
			rownumbers: true, //如果为true, 则显示一个行号列
			loadMsg:'数据加载中...',
			url:$URL,
			queryParams:{
				ClassName:'DHCHAI.BTS.DictionarySrv',
				QueryName:'QryDic',
				aTypeCode:'DiseaseCourse',
				aActive:1
			},
			columns:[[
				{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
				{field:'ID',title:'ID',width:50,hidden:true},
				{field:'DicDesc',title:'疾病病程描述',width:600}
			]]
		});
    }
	
	$("#btnDiagCourse").click(function(e){
		obj.refreshgridDiagCourse();
		$('#LayerDiagCourse').show();
		obj.LayerCourse();	
	});
	
}