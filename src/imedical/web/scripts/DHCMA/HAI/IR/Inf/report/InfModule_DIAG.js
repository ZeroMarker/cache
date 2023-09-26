function InitDiag(obj){
	// 感染诊断
	obj.refreshINFDiagnos = function(){
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
				$('#txtInfoLoc').val(rowData['ID']);			
			}
		});
		
		//日期改变事件
		$('#txtInfDate').datebox({
			onChange: function(newValue, oldValue){				
				var InfDate = newValue;
				var InfType  = Common_RadioValue("radInfType");
				var InfPos = $('#cboInfPos').combobox('getText');
				var AdmDate = obj.AdmInfo.rows[0].AdmDate;		
				var Day = DateDiff(InfDate,AdmDate);
				if ((InfPos.indexOf("手术切口")>0||InfPos.indexOf("或腔隙")>0)) {  //手术感染，感染日期在入院前三天
					$('#cboInfLoc').lookup('enable'); //感染科室可选
				} else {
					$('#cboInfLoc').lookup('disable');
					if(InfType==1) {
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
				$('#cboInfPos').combobox('setValue',RepDiag.InfPosID);
				$('#cboInfPos').combobox('setText',RepDiag.InfPos);
				$('#cboInfSub').combobox('setValue',RepDiag.InfSubID);
				$('#cboInfSub').combobox('setText',RepDiag.InfSub);
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
			$('#cboInfPos').combobox('setValue',InfPosID);
			$('#cboInfPos').combobox('setText',InfPos);
			$('#cboInfSub').combobox('setValue',InfSubID);
			$('#cboInfSub').combobox('setText',InfSub);
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
		var InfPosID = $('#cboInfPos').combobox('getValue');
		var InfSubID = $('#cboInfSub').combobox('getValue');
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
			errorStr = errorStr + "请填写感染诊断!<br>"; 
		}
		if (!InfDate) {
			errorStr = errorStr + "请填写感染日期!<br>"; 
		}else {	
			if (InfType==1){  //医院感染
			    if (AdmDate==InfDate) {
					errorStr = errorStr + "感染类型为医院感染，感染日期不能是入院第一天!<br>";
				}
				if ((Common_CompareDate(AdmDate,InfDate)>0)||(Common_CompareDate(InfDate,DischDate)>0)||(Common_CompareDate(InfDate,NowDate)>0)) {
					errorStr = errorStr + "感染时间需要在住院期间且不应超出当前日期!<br>"; 
				}
				if (!InfLoc)  {
					errorStr = errorStr + "根据感染日期无法找到感染归属科室，请检查填写是否有误!<br>"; 
				}
			}else {
				if ((Common_CompareDate(InfDate,DischDate)>0)||(Common_CompareDate(InfDate,NowDate)>0)) {
					errorStr = errorStr + "社区感染时间需要在出院之前且不应超出当前日期!<br>"; 
				}
			}
		}
		if (InfXDate) {
			if (Common_CompareDate(InfDate,InfXDate)>0){
    			errorStr = errorStr + "感染结束日期不能在感染日期之前!<br>"; 
    		}
			if ((Common_CompareDate(InfXDate,DischDate)>0)||(Common_CompareDate(InfXDate,NowDate)>0)) {
				errorStr = errorStr + "感染结束日期需在住院期间且不应超出当前日期!<br>"; 
			}
    		if (!InfEffectID){
				errorStr = errorStr + "感染结束后感染转归不能为空!<br>"; 
		    }
		} else {
			if ((InfEffect=='治愈')||(InfEffect=='死亡')||(InfEffect=='好转')){
				errorStr = errorStr + "感染转归为治愈、死亡、好转感染结束日期不能为空!<br>"; 
			}
		}
		if (((InfEffect=='死亡')||(obj.AdmInfo.rows[0].IsDeath=='1'))&&(!DeathRelationID)) {
			errorStr = errorStr + "感染转归为死亡、死亡病例，请填写感染与死亡关系!<br>"; 
		}
		if (errorStr!="") { 
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
			title:'诊断依据-选择',
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
				aInfPosID:$('#cboInfPos').combobox('getValue')
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