function InitEnviHyMiniWinEvent(obj){	
	obj.loadEvents=function(){    	
		// 申请
		$("#btnAdd").on('click', function(){
			obj.Report="";
			obj.ApplyResultEdit();				
		});
		for (var indSpec = 1; indSpec <= 20; indSpec++){
			//结果类型 下拉框
			Common_ComboDicCode("cboRstType"+indSpec,"EHRstType",0);
			//致病菌 放大镜
			Common_LookupToBact("txtRstBactDesc"+indSpec,"txtRstBactID"+indSpec);
		}
		$("#btnQuery").on('click', function(){
			obj.reloadgridApply();	
		});
	}
	$('#ApplyResultAdd').dialog({
		title: '卫生学结果录入',
		iconCls:'icon-w-paper',
		width: 700,
		height:370,
		closed: true, 
		modal: true,
		isTopZindex:true
	});
	obj.ApplyResultEdit = function(){
		//初始化
		
		$('#Result').attr("style","display:none"); //不显示div
		
		$('#addA').show();	
		obj.execute =0;  //执行
		$('#cboAHospital').combobox('enable');
		$('#cboALoc').combobox('enable');
		$('#cboAEvItem').combobox('enable');
		$('#cboAEvObject').combobox('enable');
		$('#txtEHEnterTypeDr').combobox('disable');
		websys_enable('txtCenterNum');
		websys_enable('txtSurroundNum');
		websys_enable('txtReferToNum');
		websys_enable('AEvObjectTxt');	
		
		//obj.cboAHospital = Common_ComboToSSHosp("cboAHospital",LogonHospID);
   		//obj.cboALoc = Common_ComboToLoc('cboALoc',LogonHospID);	
		//$('#cboAHospital').combobox('setValue',LogonHospID);
		$('#cboALoc').combobox('setValue',LogonLocID);
		$('#cboALoc').combobox('setText',LogonLocDesc);
			
		var AMonitorDate=Common_GetDate(new Date());
		$('#AMonitorDate').datebox('setValue',AMonitorDate);
		$('#cboAEvObject').combobox('setValue','');
		$('#txtCenterNum').val('');
		$('#txtSurroundNum').val('');
		$('#AEvObjectTxt').val('');
		$('#txtReferToNum').val('');
		$('#cboAEvItem').combobox('setValue','');
		$('#txtEHEnterTypeDr').combobox('setValue','');
		$.each($("#tableEnterResult2 tr"),function(index){
			$(this).hide();
		})
		$HUI.combobox("#cboAEvItem",{
			url:$URL+'?ClassName=DHCHAI.IRS.EnviHyItemSrv&QueryName=QryEvItem&ResultSetType=Array&aLocID='+$('#cboALoc').combobox('getValue'),
			valueField:'ID',
			textField:'ItemDesc',
			allowNull: true, 
			onSelect:function(row){
				var IsObjNull = row.IsObjNull;	//获取对象是否允许为空
				$('#AEvIsObjNull').val(IsObjNull);
				//$('#AEvIsObjNull',IsObjNull);
				if (obj.execute==1) return;
				obj.LoadEvObjectSpen(row.ID);
			},onChange:function(newvalue,oldvalue){
				obj.LoadEvObjectSpen(newvalue);
			}
		});		
		//申请单编辑modal
		$HUI.dialog('#ApplyResultAdd').open();
	}
	
	obj.LoadEvObjectSpen = function(EvItemID){
		obj.execute =1;  //执行
		var EvObjectdata=$cm({
			ClassName:'DHCHAI.IRS.EnviHyItemSrv',
			QueryName:'QryEvObjsByItem',
			ResultSetType:'array',
			aParRef:EvItemID	
		},false);

		$HUI.combobox("#cboAEvObject",{
			data:EvObjectdata,
			valueField:'ObjID',
			textField:'ObjDesc',
			editable:false,
			onLoadSuccess:function(data){
				//只有一条记录默认加载
				if (data.length==1) {
					$('#cboAEvObject').combobox('select',data[0]['ObjID']);
				}
			}
		});
	
		var SpenNum = $m({
			ClassName:'DHCHAI.IR.EnviHyItem',
			MethodName:'GetSpenNumById',
			Id:EvItemID
		},false)
		var SpenNumArr=SpenNum.split("^");
		obj.CenterNum=SpenNumArr[1];
		obj.SurroundNum=SpenNumArr[2];
		var ReferToNum=SpenNumArr[3];
		var EHIsSpecNum=SpenNumArr[4];
		obj.EHEnterTypeDr=SpenNumArr[5];
		var EHEnterTypeDesc=SpenNumArr[6];
		$('#txtCenterNum').val(obj.CenterNum);
		$('#txtSurroundNum').val(obj.SurroundNum);
		$('#txtReferToNum').val(ReferToNum);	

		if (EHIsSpecNum==0) { //如果不允许调整标本数量，则禁用录入框
			websys_disable('txtCenterNum');
			websys_disable('txtSurroundNum');
			websys_disable('txtReferToNum');
		}
		
		if ((obj.EHEnterTypeDr==0)||(obj.EHEnterTypeDr==2)) {
			$.messager.alert("错误提示","录入方式为空或者录入方式为按标本录入，请到监测项目界面修改！", 'info');
			$('#addA').hide();
			return;
		}else {
			$('#addA').show();
			$('#txtEHEnterTypeDr').combobox('setValue',obj.EHEnterTypeDr);
			$('#txtEHEnterTypeDr').combobox('setText',EHEnterTypeDesc);
			var isEdit=1;
			if(obj.EHEnterTypeDr==3){			//
				//中心值、周边值、项目值、参照值-->赋值
				$.each($("#tableEnterResult2 tr"),function(index){
					if (index<1) {
						$(this).show();	
					} else {
						if (index<2){
							$(this).show();
							$('#cboRstType'+index).combobox({disabled:(!isEdit)});
							$('#txtResult'+index).attr("disabled",(!isEdit));
							$('#txtRstBactDesc'+index).lookup({disabled:(!isEdit)});
						} else {
							$(this).hide();
						}
					}
				})
				//表单设置初始值
				for (var row = 1; row <= 20; row++){		
					if(row<=1){
						$('#cboRstType'+row).combobox('setValue','');
						$('#txtResult'+row).val("");
						$('#txtRstBactID'+row).val("");
						$('#txtRstBactDesc'+row).val("");
						$("#lblItemNum"+row).text("中心值");
					}else if(row<=2){
						$('#cboRstType'+row).combobox('setValue','');
						$('#txtResult'+row).val("");
						$('#txtRstBactID'+row).val("");
						$('#txtRstBactDesc'+row).val("");
						$("#lblItemNum"+row).text("周边值");
					}
				}
				
			}else if(obj.EHEnterTypeDr==1){
				//中心值、周边值、项目值、参照值-->赋值
				$.each($("#tableEnterResult2 tr"),function(index){
					if (index<1) {
						$(this).show();	
					} else {
						$(this).hide();
					}
				})
				//表单设置初始值
				for (var row = 1; row <= 20; row++){		
					if(row<=1){
						$('#cboRstType'+row).combobox('setValue','');
						$('#txtResult'+row).val("");
						$('#txtRstBactID'+row).val("");
						$('#txtRstBactDesc'+row).val("");
						$("#lblItemNum"+row).text("项目值");
					}
				}
			}
			$('#Result').removeAttr("style"); //显示div
			$.parser.parse('#Result');        //需要再次解析 不解析全部界面时 滚动条压边，解析全部清空填写数据(除文本框以外)
		}
	}
	// 申请、修改申请记录
	$('#addA').on('click', function(){

		var ReCheckRepID="",IsReCheck="",ReportID=""
	
		var HospitalDr      = $("#cboAHospital").combobox('getValue');
		var MonitorLocDr    = $("#cboALoc").combobox('getValue');
		var MonitorDate   	= $("#AMonitorDate").datebox('getValue');
		var EvItemDr 		= $("#cboAEvItem").combobox('getValue');
		var EvObjectDr   	= $("#cboAEvObject").combobox('getValue');
		var EHItemObjTxt   	= $("#AEvObjectTxt").val();
		var CenterNum		= $("#txtCenterNum").val();
		var SurroundNum		= $("#txtSurroundNum").val();
		var ReferToNum		= $("#txtReferToNum").val();
		var SpecimenNum    	= parseInt(CenterNum)+parseInt(SurroundNum)+parseInt(ReferToNum);
		var IsObjNull		= $("#AEvIsObjNull").val();
		
		//录入结果信息（中心值、周边值、项目值、参照值-->取值）
		var resultInfo = '';
		var ErrorMsg="";
		$.each($("#tableEnterResult2 tr"),function(index){
			if (index>=0) {
				if(obj.EHEnterTypeDr==3){
					if (index<1){
						var i = parseInt(index)+1;
						RstTypeCode  = $('#cboRstType'+i).combobox('getValue');
						RstTypeDesc  = $('#cboRstType'+i).combobox('getText');
						Result       = $('#txtResult'+i).val();
						BactID       = $('#txtRstBactID'+i).val();
						BactDesc     = $('#txtRstBactDesc'+i).val();
						SpecNumDesc	 = "中心值";
						if (((RstTypeDesc!="未检出")&&(!Result)) ||(!RstTypeCode)){
							ErrorMsg = ErrorMsg+ '第'+i+'行请录入正确的结果信息！</br>'
						}
						
						var rowInfo = i + '^' + SpecNumDesc + '^' + RstTypeCode + '^' + RstTypeDesc + '^' + Result + '^' + BactID + '^' + BactDesc
						
						if (resultInfo!=''){
							resultInfo += '!!' + rowInfo;
						} else {
							resultInfo = rowInfo;
						}
						
					}else if(index<2){
						var i = parseInt(index)+1;
						RstTypeCode  = $('#cboRstType'+i).combobox('getValue');
						RstTypeDesc  = $('#cboRstType'+i).combobox('getText');
						Result       = $('#txtResult'+i).val();
						BactID       = $('#txtRstBactID'+i).val();
						BactDesc     = $('#txtRstBactDesc'+i).val();
						SpecNumDesc	 = "周边值";
						if (((RstTypeDesc!="未检出")&&(!Result)) ||(!RstTypeCode)){
							ErrorMsg = ErrorMsg+ '第'+i+'行请录入正确的结果信息！</br>'
						}
						var rowInfo = i + '^' + SpecNumDesc + '^' + RstTypeCode + '^' + RstTypeDesc + '^' + Result + '^' + BactID + '^' + BactDesc
					
						if (resultInfo!=''){
							resultInfo += '!!' + rowInfo;
						} else {
							resultInfo = rowInfo;
						}
					}else{
						return;	
					}
						
				}else if(obj.EHEnterTypeDr==1){
					if (index<1){
						RstTypeCode  = $('#cboRstType'+"1").combobox('getValue');
						RstTypeDesc  = $('#cboRstType'+"1").combobox('getText');
						Result       = $('#txtResult'+"1").val();
						BactID       = $('#txtRstBactID'+"1").val();
						BactDesc     = $('#txtRstBactDesc'+"1").val();
						SpecNumDesc	 = "项目值";
						if (((RstTypeDesc!="未检出")&&(!Result)) ||(!RstTypeCode)){
							ErrorMsg = ErrorMsg+ '第'+(parseInt(index)+1)+'行请录入正确的结果信息！</br>'
						}
						var rowInfo = (parseInt(index)+1) + '^' + SpecNumDesc + '^' + RstTypeCode + '^' + RstTypeDesc + '^' + Result + '^' + BactID + '^' + BactDesc		
						
						if (resultInfo!=''){
							resultInfo += '!!' + rowInfo;
						} else {
							resultInfo = rowInfo;
						}
					}else{
						return;	
					}
				}
			}
		});
		var ErrorStr = ErrorMsg;
		
		var InfEnviHyItem = $m({
			ClassName:"DHCHAI.IR.EnviHyItem",
			MethodName:"GetObjById",
			id:EvItemDr
			},false);
		if (InfEnviHyItem!=""){
			var cm=JSON.parse(InfEnviHyItem);
			var EHSpecimenNum = cm.EHSpecimenNum
		}
		
		if (HospitalDr == '') {
			ErrorStr += '院区不允许为空！<br/>';	
		}
		if (MonitorLocDr == '') {
			ErrorStr += '监测科室不允许为空！<br/>';
		}
		if (MonitorDate == '') {
			ErrorStr += '监测日期不允许为空！<br/>';
		}
		if (EvItemDr == '') {
			ErrorStr += '监测项目不允许为空！<br/>';
		}
		if ((IsObjNull==0)&&(EvObjectDr == '')) {
			ErrorStr += '监测对象不允许为空！<br/>';
		}
		if (SpecimenNum == 0) {
			ErrorStr += '标本数量不允许为空！<br/>';
      
		}
		if ((parseInt(EHSpecimenNum))<parseInt(SpecimenNum)) {
			ErrorStr = ErrorStr + "参照点个数、中心个数、周边个数总数不允许大于标本个数!<br>";
		}
		if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}
		if(typeof(obj.Report.ReportID)=="undefined"){
			var ReportID="";
		}else{
			ReportID=obj.Report.ReportID;	
		}
		var InputStr = ReportID;
		InputStr += "^" + EvItemDr;
		InputStr += "^" + EvObjectDr;
		InputStr += "^" + 1;
		InputStr += "^" + MonitorDate;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + LogonLocID;
		InputStr += "^" + LogonUserID;
		InputStr += "^" + SpecimenNum;
		InputStr += "^" + CenterNum;
		InputStr += "^" + SurroundNum;
		InputStr += "^" + ''; 			//RepDate
		InputStr += "^" + ''; 			//RepTime
		InputStr += "^" + ''; 			//RepLocDr
		InputStr += "^" + ''; 			//RepUserDr
		InputStr += "^" + ''; 			//Standard
		InputStr += "^" + ''; 			//Resume
		InputStr += "^" + ''; 			//CollDate
		InputStr += "^" + ''; 			//CollTime
		InputStr += "^" + ''; 			//CollUserDr
		InputStr += "^" + ''; 			//RecDate
		InputStr += "^" + ''; 			//RecTime
		InputStr += "^" + ''; 			//RecUserDr
		InputStr += "^" + ''; 			//IsRstByItm
		InputStr += "^" + IsReCheck; 	//IsReCheck
		InputStr += "^" + ReCheckRepID; //ReCheckRepDr
		InputStr += "^" + EHItemObjTxt; //ItemObjTxt
		InputStr += "^" + MonitorLocDr; 			
		InputStr += "^" + ReferToNum; 			
		
		$m({
			ClassName:"DHCHAI.IR.EnviHyReport",
			MethodName:"Update",
			InStr:InputStr
		},function(retval){
			if (parseInt(retval)>0){
				// 保存日志
				var LogStr = retval;
				LogStr = LogStr + '^' + LogonLocID;
				LogStr = LogStr + '^' + LogonUserID;
				LogStr = LogStr + '^' + 1;
				LogStr = LogStr + '^' + '';
				var retvalLog = $m({
					ClassName:"DHCHAI.IR.EnviHyReportLog",
					MethodName:"Update",
					aInput:LogStr
				});
				
				//基本信息
				var baseInfo = parseInt(retval);
				baseInfo += '^' + "";
				baseInfo += '^' + LogonLocID;
				baseInfo += '^' + LogonUserID;
				baseInfo += '^' + '4';  //4录入结果
				
				var flg = $m({
					ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
					MethodName  : "SaveReportResults",
					aBaseInfo   : baseInfo,
					aResultInfo : resultInfo
				},false);
				if (parseInt(flg) < 1) {
					bClose = false;
					$.messager.alert("错误提示","录入结果操作错误!Error=" + flg, 'info');
					return ;
				} else {
					bClose = true;
					$.messager.popover({msg: '录入结果操作成功！',type:'success',timeout: 1000});
					
				}
				$HUI.dialog('#ApplyResultAdd').close();
				obj.reloadgridApply();
			} else {
				$.messager.alert("错误提示","保存失败:"+retval, 'info');
			}
		})
		
		
	})
	//重新加载表格数据
	obj.reloadgridApply = function(){

		var aHospIDs=$("#cboHospital").combobox('getValue');
		var aDateType='MonitorDate';
		var aDateFrom=$("#txtStartDate").datebox('getValue');
		var aDateTo=$("#txtEndDate").datebox('getValue');
		var	aMonitorLoc=$("#cboMonitorLoc").combobox('getValue');
		var	aItemID='';
		var	aStatusCode='';
		var	aFlowFlg='';
		var	aStandard=$("#cboStandard").combobox('getValue');
		var ErrorStr="";
		if (aStandard=="0"){
			aStandard="N";
		}else if(aStandard=="1"){
			aStandard="Y";	
		}else{
			aStandard="";	
		}
		if (aHospIDs=="") {
			ErrorStr += '请选择院区!<br/>';
		}
		if (aDateFrom=="") {
			ErrorStr += '请选择监测开始日期!<br/>';
		}
		if (aDateTo == "") {
			ErrorStr += '请选择监测结束日期!<br/>';
		}
		if (aDateFrom > aDateTo) {
			ErrorStr += '监测开始日期不能大于监测结束日期!<br/>';
		}
		if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}else{
			$('#gridReuslt').datagrid('load',{
				ClassName:'DHCHAI.IRS.EnviHyReportSrv',
		        QueryName:'QryEvReport',
		        aHospIDs:aHospIDs,
		        aDateType:aDateType,
		        aDateFrom:aDateFrom,
		        aDateTo:aDateTo,
		        aMonitorLoc:aMonitorLoc,
		        aItemID:aItemID,
		        aStatusCode:aStatusCode,
		        aFlowFlg:"", //按标本状态筛查
		        aStandard:aStandard
			});
		}
		$('#gridReuslt').datagrid('unselectAll');
	};
	//录入结果窗体-初始化
	obj.winEnterResult_show= function(objRep,isEdit){
		
		if(obj.Report.EnterTypeDesc=="按标本"){
			$.messager.alert("错误提示","按标本录入数据不允许查看", 'info');
			return;
		}
		
		$('#cboAHospital').combobox('disable');
		$('#cboALoc').combobox('disable');
		$('#cboAEvItem').combobox('disable');
		$('#cboAEvObject').combobox('disable');
		$('#txtEHEnterTypeDr').combobox('disable');
		websys_disable('txtCenterNum');
		websys_disable('txtSurroundNum');
		websys_disable('txtReferToNum');
		websys_disable('AEvObjectTxt');	
		
		$('#cboAHospital').combobox('setValue',obj.Report.HospID);
		$('#cboAHospital').combobox('setText',obj.Report.HospDesc);
		$('#cboALoc').combobox('setValue',obj.Report.MonitorLocID);
		$('#cboALoc').combobox('setText',obj.Report.MonitorLocDesc);
		$('#AMonitorDate').datebox('setValue',obj.Report.MonitorDate);
		$('#cboAEvItem').combobox('setValue',obj.Report.EvItemID);
		$('#cboAEvItem').combobox('setText',obj.Report.EvItemDesc);
		$('#cboAEvObject').combobox('setValue',obj.Report.EvItemObjID);	
		$('#cboAEvObject').combobox('setText',obj.Report.EvItemObjDesc.split("[")[0]);	
		$('#AEvObjectTxt').val(obj.Report.EHItemObjTxt);
		$('#txtCenterNum').val(obj.Report.RepCenterNum);
		$('#txtSurroundNum').val(obj.Report.RepSurroundNum);
		$('#txtReferToNum').val(obj.Report.ReferToNum);	
		$("#AEvIsObjNull").val(obj.Report.IsObjNull);
		$('#txtEHEnterTypeDr').combobox('setValue',obj.Report.EnterTypeId);
		$('#txtEHEnterTypeDr').combobox('setText',obj.Report.EnterTypeDesc);	
		
		obj.arrResult = obj.GetResult(obj.Report.ReportID,obj.Report.Barcode);
		
		//中心值、周边值、项目值、参照值-->赋值
		$.each($("#tableEnterResult2 tr"),function(index){
			var	ReferToNum=$("#txtReferToNum").val();
			var length=obj.arrResult.length-parseInt(ReferToNum)-1;
			if (index<length) {
				var i=parseInt(index)+1;
				var objResult = obj.arrResult[i];
				if (objResult){
					$(this).show();
					$('#cboRstType'+i).combobox({disabled:(!isEdit)});
					$('#txtResult'+i).attr("disabled",(!isEdit));
					$('#txtRstBactDesc'+i).lookup({disabled:(!isEdit)});
				} else {
					$(this).hide();
				}
			}else {
				$(this).hide();
			}
		})
		$('#txtRstItem').attr("disabled",true);
		$('#txtRstObject').attr("disabled",(!isEdit));
		
		//表单设置初始值
		for (var row = 1; row <= 20; row++){
			var objResult = obj.arrResult[row];
			if (objResult){
				if(objResult.SpecNumDesc!="参照值"){
					$("#lblItemNum"+row).text(objResult.SpecNumDesc);
					$('#cboRstType'+row).combobox('setValue',objResult.RstTypeCode);
					$('#cboRstType'+row).combobox('setText',objResult.RstTypeDesc);
					$('#txtResult'+row).val(objResult.Result);
					$('#txtRstBactID'+row).val(objResult.BactID);
					$('#txtRstBactDesc'+row).val(objResult.BactDesc);
				}
			}
		}
		
		//录入结果弹窗
		$HUI.dialog('#ApplyResultAdd').open();
	}
	//获取报告对象
	obj.GetResult = function(aRepId,aBarcode){
		var rstInfo = $m({
			ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
			MethodName  : "GetReportResults",
			aReportID  : aRepId,
			aBarcode    : aBarcode
		},false);
		if (!rstInfo) return '';
		
		var arrInfo = rstInfo.split('!!');
		var arrResult = new Array();
		for (indRow = 0; indRow < arrInfo.length; indRow++){
			var rowInfo = arrInfo[indRow];
			if (!rowInfo) continue;
			var rd = rowInfo.split('^');
			var objResult = new Object();
			objResult.SpecNumber   = rd[0];
			objResult.SpecNumDesc  = rd[1];
			objResult.RstTypeCode  = rd[2];
			objResult.RstTypeDesc  = rd[3];
			objResult.Result       = rd[4];
			objResult.BactID       = rd[5];
			objResult.BactDesc     = rd[6];
			arrResult[objResult.SpecNumber] = objResult;
		}
		return arrResult
	}
	//关闭
	$('#closeA').on('click', function(){
		
		$HUI.dialog('#ApplyResultAdd').close();
	})
	
}