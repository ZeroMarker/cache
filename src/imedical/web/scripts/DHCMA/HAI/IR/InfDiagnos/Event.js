//页面Event
function InitInfDiagnosWinEvent(obj){	
    var oldInfDate='';
    obj.LoadEvent = function(args){
		
		//保存
		$('#btnSave').on('click', function(){
	     	obj.SaveInfPos();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	websys_showModal('close');
     	});
		
		obj.OpenInfPosDialog(EpisodeID,DiagID,AdmitDate,DischDate);
	}
	//转归处理
	obj.OpenInfPosDialog = function(EpisodeID,DiagID,AdmitDate,DischDate){
		if (!DiagID) return;
				//如果是审核状态得只让编辑感染转归日期，感染转归时间
		if(State=="1"){
			 $('#radInfType-1'). checkbox ('disable');
			 $('#radInfType-0'). checkbox ('disable');
			 $('#cboInfPos').combotree('disable');
			 $('#txtInfDate').datebox('disable');
			 $('#cboDeathRelation').combobox('disable');
			 $('#txtDiagnosisBasis').attr("disabled","disabled");
			 $('#txtDiseaseCourse').attr("disabled","disabled");	 
			}
			else
			{
			 $('#radInfType-1'). checkbox ('enable');
			 $('#radInfType-0'). checkbox ('enable');
			 $('#cboInfPos').combotree('enable');
			 $('#txtInfDate').datebox('enable');
			 $('#cboDeathRelation').combobox('enable');
			 $('#txtDiagnosisBasis').removeAttr("disabled");
			 $('#txtDiseaseCourse').removeAttr("disabled");
			}
		obj.EpisodeID = EpisodeID;
		obj.DiagnosID = DiagID;
		obj.AdmitDate = AdmitDate;
		obj.DischDate = DischDate;
        
		rowData = $m({
			ClassName:"DHCHAI.IRS.INFDiagnosSrv",
			MethodName:"GetStrByRowID",
			aID:DiagID
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
		var InfDiagnosisBasis = arrData[8];
		var InfDiseaseCourse = arrData[9];
	    
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
		$('#txtDiagnosisBasis').val(InfDiagnosisBasis);
		$('#txtDiseaseCourse').val(InfDiseaseCourse);
		$('#txtInfLoc').val(InfLocID);	
		$('#cboInfLoc').lookup('setText',InfLoc);				
		obj.IsReportDiag = IsReportDiag;	// 是否临床上报诊断	
    }
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
				$('#txtInfDate').datebox('setValue',obj.AdmitDate);
			}
		}
	});

	//日期改变事件
	$('#txtInfDate').datebox({
		onChange: function(newValue, oldValue){				
			var InfDate = newValue;
			if (InfDate==""){
				return;
			}
			var InfType  = Common_RadioValue("radInfType");
			var InfPos = $('#cboInfPos').combotree('getText');
			var Day = DateDiff(InfDate,obj.AdmitDate);
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
		
	 //保存感染信息
	obj.SaveInfPos = function() {
		var errorStr = '';
		var InfType  = Common_RadioValue("radInfType");
		//var InfPosID = $('#cboInfPos').combobox('getValue');
		//var InfSubID = $('#cboInfSub').combobox('getValue');
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
		var NowDate = Common_GetDate(new Date());	
	    var InfLoc = $('#txtInfLoc').val();	
		
		if (!InfPosID) {
			errorStr = errorStr + "请填写感染诊断!<br>"; 
		}
		if (!InfDate) {
			errorStr = errorStr + "请填写感染日期!<br>"; 
		}else {		
			if (InfType==1){  //医院感染
			    if (obj.AdmitDate==InfDate) {
					errorStr = errorStr + "感染类型为医院感染，感染日期不能是入院第一天!<br>";
				}
				if ((Common_CompareDate(obj.AdmitDate,InfDate)>0)||(Common_CompareDate(InfDate,obj.DischDate)>0)||(Common_CompareDate(InfDate,NowDate)>0)) {
					errorStr = errorStr + "感染时间需要在住院期间且不应超出当前日期!<br>"; 
				}
				if (!InfLoc)  {
					errorStr = errorStr + "根据感染日期无法找到感染归属科室，请检查填写是否有误!<br>"; 
				}
			}else {	
				var Day = DateDiff(InfDate,obj.AdmitDate);
				if ((Day>=3)||(Common_CompareDate(InfDate,NowDate)>0)) {
					errorStr = errorStr + "社区感染日期只能在入院前3天且不应超出当前日期!<br>"; 
				}	
			}	
		}
		
		if (InfXDate) {
			if (Common_CompareDate(InfDate,InfXDate)>0){
    			errorStr = errorStr + "感染结束日期不能在感染日期之前!<br>"; 
    		}
			if ((Common_CompareDate(InfXDate,obj.DischDate)>0)||(Common_CompareDate(InfXDate,NowDate)>0)) {
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
		if ((InfEffect=='死亡')&&(!DeathRelationID)) {
			errorStr = errorStr + "感染转归为死亡，请填写感染与死亡关系!<br>"; 
		}
		
		if (errorStr!="") { 
			$.messager.alert("提示", errorStr, 'info');
			return; 
		}
		if (InfType==1) {
			var TransInfo = $m({
				ClassName:"DHCHAI.DPS.PAAdmTransSrv",
				MethodName:"GetTransInfoByDate",		
				aEpisodeDr: EpisodeID,
				aDate:InfDate
			},false);
			var InfLoc =TransInfo.split("^")[0];
			if (!InfLoc)  {
				$.messager.alert("提示", "根据感染日期无法找到感染归属科室，请检查填写是否有误!", 'info');
				return;
			}
		}
   		var Input = obj.DiagnosID;
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
		
		//保存
		var flg = $m({
			ClassName:"DHCHAI.IR.INFDiagnos",
			MethodName:"Update",
			aInputStr:Input,
			aSeparete:CHR_1
		},false);
		if (parseInt(flg) < 1) {
			$.messager.alert("错误提示","保存失败!Error=" + flg, 'info');
			return;
		} else {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		
		}
	};
		
	
	//诊断依据
	$("#btnDiagBasis").on('click',function(){
		obj.refreshgridDiagBasis();
		$('#LayerDiagBasis').show();
		obj.LayerDiagBasis();
	});
	
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
	
	//感染性疾病病程
	$("#btnDiagCourse").on('click',function(){
		obj.refreshgridDiagCourse();
		$('#LayerDiagCourse').show();
		obj.LayerCourse();	
	});
	
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
	
}