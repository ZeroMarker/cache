var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
var CHR_3 = String.fromCharCode(3);
var CHR_4 = String.fromCharCode(4);
var CHR_5 = String.fromCharCode(5);
var CHR_6 = String.fromCharCode(6);
var CHR_7 = String.fromCharCode(7);
var CHR_8 = String.fromCharCode(8);

function InitReportWin(ActFlag)
{
	var obj = new Object();
	obj.InputRep 		= "";			// 报告主表信息
	obj.InputRepLog 	= "";			// 日志
	// 初始化模块
	obj.AdminPower  = AdminPower;
	obj.RepStatusCode = '';
	obj.DiagList = ServerObj.DiagList;
	
	//加载下拉框及其事件
	//Common_ComboDicID("cboCSSDiagnos","IRCSSDiagnos");
	//Common_ComboDicID("cboCSSIncisionDr","CuteType");
	//Common_ComboDicID("cboIRInfectionDr","INFCSSIsExt");
	//Common_ComboDicID("cboInfCategoryDr","IRCSSINFTYPE");
	//Common_ComboDicID("cboCSSOperLung","OEYesNo");
	//Common_ComboDicID("cboCSSMedPurpose","AntiMedPurpose");
	//Common_ComboDicID("cboCSSCombinedMed","AntiCombinedMed");
	loadDiagnos();
	loadOpr();
	loadIncisionDr();
	loadInfection();
	loadInfCategory();
	loadInfPos();
	loadBacteria();
	loadOperLung();
	loadMedPurpose();
	loadCombinedMed();
	loadZLSbmt();
	loadISPYSAntiBefre();

	Common_SetCombo("cboCSSOperLung","","");
	Common_SetLookup("cboYYBacteria11","","");
	Common_SetLookup("cboYYBacteria12","","");
	Common_SetLookup("cboYYBacteria13","","");
	Common_SetLookup("cboYYBacteria21","","");
	Common_SetLookup("cboYYBacteria22","","");
	Common_SetLookup("cboYYBacteria23","","");
	Common_SetLookup("cboYYBacteria31","","");
	Common_SetLookup("cboYYBacteria32","","");
	Common_SetLookup("cboYYBacteria33","","");
	Common_SetCombo("cboSQInfPos1","","");
	Common_SetCombo("cboSQInfPos2","","");
	Common_SetCombo("cboSQInfPos3","","");
	Common_SetCombo("cboSQMethod1","","");
	Common_SetCombo("cboSQMethod2","","");
	Common_SetCombo("cboSQMethod3","","");
	Common_SetLookup("cboSQBacteria11","","");
	Common_SetLookup("cboSQBacteria12","","");
	Common_SetLookup("cboSQBacteria13","","");
	Common_SetLookup("cboSQBacteria21","","");
	Common_SetLookup("cboSQBacteria22","","");
	Common_SetLookup("cboSQBacteria23","","");
	Common_SetLookup("cboSQBacteria31","","");
	Common_SetLookup("cboSQBacteria32","","");
	Common_SetLookup("cboSQBacteria33","","");
	$HUI.combobox("#cboSQMethod1",{
		data:[{Id:'1',text:'外院发生'},{Id:'2',text:'社区发生'}],
		valueField:'Id',
		textField:'text'
	});	
	$HUI.combobox("#cboSQMethod2",{
		data:[{Id:'1',text:'外院发生'},{Id:'2',text:'社区发生'}],
		valueField:'Id',
		textField:'text'
	});
	$HUI.combobox("#cboSQMethod3",{
		data:[{Id:'1',text:'外院发生'},{Id:'2',text:'社区发生'}],
		valueField:'Id',
		textField:'text'
	});
	
	$('#radIsANTVD-tr').attr("style","display:none");

	$("#dtFirInf").next("span").find("input").keydown(function(e) {
	　　if (e.which == "13") 
		{
			var FirInfDate=$("#dtFirInf").datebox("getValue");
			if (FirInfDate!=""){
				FocusJump("dtFirInf");
			}
		}
	});
	
	
	$HUI.radio("input[name='radIsVD']",{
		onChecked:function(e,value){
			if ($("input[name='radIsVD']:checked").val()=="1"){
				$('#radIsANTVD-tr').attr("style","display:display");
			}else{
				$('#radIsANTVD-tr').attr("style","display:none");
				$HUI.radio("#radIsANTVD-1").setValue(false);
				$HUI.radio("#radIsANTVD-0").setValue(false);
			}
		}
	});
	$HUI.radio("input[name='radCSSIsAnti']",{
		onChecked:function(e,value){
			if ($("input[name='radCSSIsAnti']:checked").val()=="0"){
				$('#cboCSSMedPurpose').combobox("setValue","");
				$('#cboCSSCombinedMed').combobox("setValue","");
				$('#cboCSSZLSbmt').combobox("setValue","");
				$('#cboCSSISPYSAntiBefre').combobox("setValue","");
				
				$('#cboCSSMedPurpose').combobox('disable');
				$('#cboCSSCombinedMed').combobox('disable');
				$('#cboCSSZLSbmt').combobox('disable');
				$('#cboCSSISPYSAntiBefre').combobox('disable');
			}else{
				$('#cboCSSMedPurpose').combobox('enable');
				$('#cboCSSCombinedMed').combobox('enable');
				$('#cboCSSZLSbmt').combobox('enable');
				$('#cboCSSISPYSAntiBefre').combobox('enable');
			}
		}
	})
	$("#dtFirInf").datebox('options').maxDate=$("#dtFirInf").datebox('options').formatter(new Date())  //限定最大日期
	InitBase(obj);
	InitRep(obj);
	InitFloatWin();			//加载帮助页面
	InitReportWinEvent(obj);
	if (ActFlag==1){
		obj.LoadEvent();
	}
	// 初始化功能按钮
	obj.InitButtons();
	obj.radCSSIsAnti();
	return obj;
}

function InitPatChangeWin(aEpisodeID,aReportID)
{
	EpisodeID = aEpisodeID;
	ReportID  = aReportID;
	InitReportWin("");
}

function InitPatWin(aFlag)
{
	var objS = new Object();
	//患者列表
	objS.PAAdmListLoad=function(inputParams,aChangeFlag){
		$('#ulPAAdmList').html("");
		var runQuery =$cm({
			ClassName:"DHCHAI.IRS.INFCSSSrv",
			QueryName:"QryAdm",
			aIntputs:inputParams,
			aSearch:aFlag,
			page:1,
			rows:9999
		},false);
		
		if(runQuery){
			var arrMap = runQuery.rows;
			tabsLength=arrMap.length;
			var strHtml=" <ul>"
			for (var indMap = 0; indMap < arrMap.length; indMap++){
				var rd = arrMap[indMap];
				if (!rd) continue;
				if (indMap=="0"){
					if ((aChangeFlag!=1)&&(aFlag==1)){
						InitPatChangeWin(EpisodeID,ReportID);
					}else{
						InitPatChangeWin(rd["EpisodeID"],rd["RepID"]);
					}
					
					strHtml+="<li class='active' id=\""+rd["EpisodeID"]+"\"><a href='javascript:void(0);' onclick='InitPatChangeWin(\""+rd["EpisodeID"]+"\",\""+rd["RepID"]+"\");' class='api-navi-tab'>"+rd["AdmBed"]+" "+rd["PatName"]+"</a></li>";
					continue;
				}
				strHtml+="<li id=\""+rd["EpisodeID"]+"\"><a href='javascript:void(0);' onclick='InitPatChangeWin(\""+rd["EpisodeID"]+"\",\""+rd["RepID"]+"\");' class='api-navi-tab'>"+rd["AdmBed"]+" "+rd["PatName"]+"</a></li>";
			}
			strHtml+=" <li style='height:44px;border:none;'></li></ul>"
			$('#ulPAAdmList').html(strHtml); 
			$.parser.parse('#ulPAAdmList');
		}
		if (aFlag==1){
			$(".hisui-accordion ul>li.active").removeClass('active');
			$("#"+EpisodeID).addClass('active');	
		}
		$('.api-navi-tab').on('click',function(){
	        $(".hisui-accordion ul>li.active").removeClass('active'); 
	        $(this).closest("li").addClass('active');
	 	})
	}
	$HUI.radio("input[name='chkStatunit']",{
		onChecked:function(e,value){
			var Status=Common_CheckboxValue('chkStatunit');
			objS.PAAdmListLoad(inputParams+Status,"1");
		}
	});
	tmpRepStatus=Common_CheckboxValue('chkStatunit');
	if (tmpRepStatus!=""){
		RepStatus=tmpRepStatus;
	}
	if (RepStatus=="1"){
		$('#chkStatunit-UnSub').checkbox('setValue', true);
		$('#chkStatunit-UnCheck').checkbox('setValue', false);
		$('#chkStatunit-Check').checkbox('setValue', false);
	}else if(RepStatus=="2"){
		$('#chkStatunit-UnSub').checkbox('setValue', false);
		$('#chkStatunit-UnCheck').checkbox('setValue', true);
		$('#chkStatunit-Check').checkbox('setValue', false);
	}else if(RepStatus=="3"){
		$('#chkStatunit-UnSub').checkbox('setValue', false);
		$('#chkStatunit-UnCheck').checkbox('setValue', false);
		$('#chkStatunit-Check').checkbox('setValue', true);
	}else {
		$('#chkStatunit-UnSub').checkbox('setValue', true);
	}
	
	objS.PAAdmListLoad(inputParams+RepStatus,"");
	return objS;
}
// 疾病诊断
function loadDiagnos(){
	var ItemCode = "cboCSSDiagnos";
	var DicType =  "IRCSSDiagnos";
	$HUI.combobox("#"+ItemCode, {
		valueField: 'ID',
		textField: 'DicDesc',
		blurValidValue:true, 
		allowNull:true,
		editable:false,
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+DicType+"&aActive=1";
			$("#"+ItemCode).combobox('reload',url);
		}
	});	
}
//是否手术
function loadOpr(){
	$HUI.combobox("#cboCSSIsOpr", {
		valueField: 'Code',
		textField: 'Desc',
		blurValidValue:true, 
		allowNull:true,
		editable:false,
		data:JSON.parse(ServerObj.YNData),
		onSelect:function(item){
			if (item.Code=="0"){
				$("#cboCSSIncisionDr").combobox('disable');
				Common_SetCombo("cboCSSIncisionDr","","");
			}else{
				$("#cboCSSIncisionDr").combobox('enable');
				Common_SetCombo("cboCSSIncisionDr","","");
			}
		}
	 });
}
//切口类型
function loadIncisionDr(){
	var ItemCode = "cboCSSIncisionDr";
	var DicType =  "CSSCuteType";
	$HUI.combobox("#"+ItemCode, {
		valueField: 'ID',
		textField: 'DicDesc',
		blurValidValue:true, 
		allowNull:true,
		editable:false,
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+DicType+"&aActive=1";
			$("#"+ItemCode).combobox('reload',url);
		}
	});	
}
//感染
function loadInfection(){
	var ItemCode = "cboIRInfectionDr";
	var DicType =  "INFCSSIsExt";
	$HUI.combobox("#"+ItemCode, {
		valueField: 'ID',
		textField: 'DicDesc',
		blurValidValue:true, 
		allowNull:true,
		editable:false,
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+DicType+"&aActive=1";
			$("#"+ItemCode).combobox('reload',url);
		},
		onSelect:function(item){
			if (item.DicDesc=="存在"){
				$('#cboInfCategoryDr').combobox('enable');
				Common_SetCombo("cboInfCategoryDr","","");
				changeStyle($("#cboInfCategoryDr").combobox("getText"))
			}else{
				$('#cboInfCategoryDr').combobox('disable');
				Common_SetCombo("cboInfCategoryDr","","");
				$('#cboYYInfPos1').combobox('disable');
				$('#cboYYInfPos2').combobox('disable');
				$('#cboYYInfPos3').combobox('disable');
				$('.YYBacteria').lookup('disable');
				Common_SetCombo("cboYYInfPos1","","");
				Common_SetCombo("cboYYInfPos2","","");
				Common_SetCombo("cboYYInfPos3","","");
				$("#dtFirInf").datebox('setValue',"");
				Common_SetLookup("cboYYBacteria11","","");
				Common_SetLookup("cboYYBacteria12","","");
				Common_SetLookup("cboYYBacteria13","","");
				Common_SetLookup("cboYYBacteria21","","");
				Common_SetLookup("cboYYBacteria22","","");
				Common_SetLookup("cboYYBacteria23","","");
				Common_SetLookup("cboYYBacteria31","","");
				Common_SetLookup("cboYYBacteria32","","");
				Common_SetLookup("cboYYBacteria33","","");
				$("#dtFirInf").datebox('disable');
				$('#cboCSSOperLung').combobox('disable');
				$('#cboSQInfPos1').combobox('disable');
				$('#cboSQInfPos2').combobox('disable');
				$('#cboSQInfPos3').combobox('disable');
				$('#cboSQMethod1').combobox('disable');
				$('#cboSQMethod2').combobox('disable');
				$('#cboSQMethod3').combobox('disable');
				Common_SetCombo("cboSQInfPos1","","");
				Common_SetCombo("cboSQInfPos2","","");
				Common_SetCombo("cboSQInfPos3","","");
				Common_SetCombo("cboSQMethod1","","");
				Common_SetCombo("cboSQMethod2","","");
				Common_SetCombo("cboSQMethod3","","");
				Common_SetLookup("cboSQBacteria11","","");
				Common_SetLookup("cboSQBacteria12","","");
				Common_SetLookup("cboSQBacteria13","","");
				Common_SetLookup("cboSQBacteria21","","");
				Common_SetLookup("cboSQBacteria22","","");
				Common_SetLookup("cboSQBacteria23","","");
				Common_SetLookup("cboSQBacteria31","","");
				Common_SetLookup("cboSQBacteria32","","");
				Common_SetLookup("cboSQBacteria33","","");
				$('.SQBacteria').lookup('disable');
				//add by chenjb 20221114 cboCSSOperLung 术后手术 
				$('#cboCSSOperLung').combobox('disable');
				Common_SetCombo("cboCSSOperLung","","");
			}
		} 
	});
}
//感染类型
function loadInfCategory(){
	var ItemCode = "cboInfCategoryDr";
	var DicType =  "IRCSSINFTYPE";
	$HUI.combobox("#"+ItemCode, {
		valueField: 'ID',
		textField: 'DicDesc',
		blurValidValue:true, 
		allowNull:true,
		editable:false,
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+DicType+"&aActive=1";
			$("#"+ItemCode).combobox('reload',url);
		},
		onSelect:function(item){
			changeStyle(item.DicDesc)
		}
	});
}
//感染部位
function loadInfPos(){
    // var Data=$cm({
    //     ClassName:"DHCHAI.BTS.InfPosSrv",
    //     QueryName:"QryInfPosToSelect"
    // },false);
    var Data=$cm({
        ClassName:"DHCHAI.IRS.UtilHCSSSrv",
        QueryName:"QryInfPosToSelect",
        aTypeCode:""
    },false);
    $HUI.combobox(".InfPos", {
        valueField: 'ID',
        textField: 'DiagDesc',
		//blurValidValue:true, 
		//allowNull:true,
		//editable:false,
		data:Data.rows,
		defaultFilter:6
	 });
    $.fn.combobox.defaults.keyHandler.enter=function (e) {
        debugger
        $(this).combobox('hidePanel');
        var id=$(this)[0].id;
        FocusJump(id);
    }
}
//病原体
function loadBacteria(){
	$(".YYBacteria,.SQBacteria").each(function(){
		var ID=$(this).attr("id");
		if (!ID){
			return true;
		}
		$("#"+ID).attr('data-idField',"");
			$HUI.lookup("#"+ID, {
			panelWidth:300,
			url:$URL,
			editable: true,
			mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
			isValid:true,
			pagination:true,
			loadMsg:'正在查询',	
			isCombo:true,             //是否输入字符即触发事件，进行搜索
			minQueryLen:1,             //isCombo为true时，可以搜索要求的字符最小长度
			idField: 'ID',
			textField: 'BacDesc',
			queryParams:{ClassName: 'DHCHAI.DPS.LabBactSrv',QueryName: 'QryLabBacteria'},
			columns:[[  
				{field:'ID',title:'ID',width:100},
				{field:'BacDesc',title:'病原体',width:180}
			]],
			onBeforeLoad:function(param){
				var desc=param['q'];
				if (desc=="") return false;   	
				param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
			},
			onSelect:function(index,rowData){  
				$("#"+ID).attr('data-idField',rowData['ID']);	
				FocusJump(ID);
			},
		});
	});

}
//术后肺炎
function loadOperLung(){
	var ItemCode = "cboCSSOperLung";
	var DicType =  "OEYesNo";
	$HUI.combobox("#"+ItemCode, {
		valueField: 'ID',
		textField: 'DicDesc',
		blurValidValue:true, 
		allowNull:true,
		editable:false,
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+DicType+"&aActive=1";
			$("#"+ItemCode).combobox('reload',url);
		}
	});
}
// 抗菌用药目的
function loadMedPurpose(){
	var ItemCode = "cboCSSMedPurpose";
	var DicType =  "IRCSSPurpose";    // "AntiMedPurpose";
	$HUI.combobox("#"+ItemCode, {
		valueField: 'ID',
		textField: 'DicDesc',
		blurValidValue:true, 
		allowNull:true,
		editable:false,
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+DicType+"&aActive=1";
			$("#"+ItemCode).combobox('reload',url);
		},
		onSelect:function(item){
			if (item.ID!=""){
				 $HUI.radio("#radCSSIsAnti-1").setValue(true);
			}
		}
		
	});
}
//联用
function loadCombinedMed(){
	var ItemCode = "cboCSSCombinedMed";
	var DicType =  "IRCSSCombinedMed";
	$HUI.combobox("#"+ItemCode, {
		valueField: 'ID',
		textField: 'DicDesc',
		blurValidValue:true, 
		allowNull:true,
		editable:false,
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+DicType+"&aActive=1";
			$("#"+ItemCode).combobox('reload',url);
		},
		onSelect:function(item){
			if (item.ID!=""){
				 $HUI.radio("#radCSSIsAnti-1").setValue(true);
			}
		}
	});
}
//治疗用药已送细菌培养
function loadZLSbmt(){
	$HUI.combobox("#cboCSSZLSbmt", {
		valueField: 'Code',
		textField: 'Desc',
		blurValidValue:true, 
		allowNull:true,
		editable:false,
		data:JSON.parse(ServerObj.YNData)
	 });
	 $HUI.combobox("#cboCSSSpecKS", {
		valueField: 'Code',
		textField: 'Desc',
		blurValidValue:true, 
		allowNull:true,
		editable:false,
		data:JSON.parse(ServerObj.YNData)
	 });
	 $HUI.combobox("#cboCSSSpecMZ", {
		valueField: 'Code',
		textField: 'Desc',
		blurValidValue:true, 
		allowNull:true,
		editable:false,
		data:JSON.parse(ServerObj.YNData)
	 });
	 $HUI.combobox("#cboCSSSpecGL", {
		valueField: 'Code',
		textField: 'Desc',
		blurValidValue:true, 
		allowNull:true,
		editable:false,
		data:JSON.parse(ServerObj.YNData)
	 });
	 $HUI.combobox("#cboCSSSpecJY", {
		valueField: 'Code',
		textField: 'Desc',
		blurValidValue:true, 
		allowNull:true,
		editable:false,
		data:JSON.parse(ServerObj.YNData)
	 });
}
//送培养时机为抗菌药物使用前
function loadISPYSAntiBefre(){
	$HUI.combobox("#cboCSSISPYSAntiBefre", {
		valueField: 'Code',
		textField: 'Desc',
		blurValidValue:true, 
		editable:false,
		data:JSON.parse(ServerObj.YNData)
	 });
}

function loadCombobox(){
	$("input.combobox-f").combobox({
		keyHandler:{
			left: function () {
				return false;
			},
			right: function () {
				return false;
			},
			up: function (e) {
				e.preventDefault();
				var Data=$(this).combobox("getData");
				var CurValue=$(this).combobox("getValue");
				var valueField=$(this).combobox('options')['valueField'];
				//取得上一行
				for (var i=0;i<Data.length;i++) {
					if (Data[i] && Data[i][valueField]==CurValue) {
						if (i>0) $(this).combobox("select",Data[i-1][valueField]);
						break;
					}
				}
			 },
			 down: function (e) {
				 e.preventDefault();
				var Data=$(this).combobox("getData");
				var CurValue=$(this).combobox("getValue");
				if ($(this).combobox('panel').is(":hidden")){
					$(this).combobox('showPanel');
					return false;
				}
				var valueField=$(this).combobox('options')['valueField'];
				//取得下一行
				for (var i=0;i<Data.length;i++) {
					if (CurValue!="") {
						if (Data[i] && Data[i][valueField]==CurValue) {
							if (i < Data.length-1) $(this).combobox("select",Data[i+1][valueField]);
							break;
						}
					}else{
						$(this).combobox("select",Data[0][valueField]);
						break;
					}
				}
				
			},
			enter: function (e) { 
				$(this).combobox('hidePanel');
				var id=$(this)[0].id;
				FocusJump(id);
			}
		}
	})
}
function FocusJump(id){
	_$combobox=$("input.combobox-f,#dtFirInf,input.YYBacteria,input.SQBacteria");
	if (_$combobox.length>0){
		var comboNum=_$combobox.length;
		var flag=false;
		for (var i=0;i<comboNum;i++){ 
			if (id==_$combobox[i].id){
				flag=true;
				continue;
			}
			if ($(_$combobox[i]).is(':disabled')){
				continue;
			}
			if (flag){
				//过滤 _$combobox[i]
				setFocus(_$combobox[i].id);
				break;
			}
		}
	}
}
function setFocus(id){
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		$("#"+id).focus();
	}
	if ((className.indexOf("combobox")>=0)||(className.indexOf("hisui-datebox")>=0)){     //||(className.indexOf("lookup")>=0)
		$("#"+id).next('span').find('input').focus();
	}else{
		$("#"+id).focus();
	}
}

function changeStyle(DicDesc){
	if (DicDesc=="社区感染"){
		$("#dtFirInf").datebox('disable');
		$('#cboYYInfPos1').combobox('disable');
		$('#cboYYInfPos2').combobox('disable');
		$('#cboYYInfPos3').combobox('disable');
		$('.YYBacteria').lookup('disable');
		$('#cboCSSOperLung').combobox('disable');
		$('#cboSQInfPos1').combobox('enable');
		$('#cboSQInfPos2').combobox('enable');
		$('#cboSQInfPos3').combobox('enable');
		$('#cboSQMethod1').combobox('enable');
		$('#cboSQMethod2').combobox('enable');
		$('#cboSQMethod3').combobox('enable');
		$('.SQBacteria').lookup('enable');
		Common_SetCombo("cboYYInfPos1","","");
		Common_SetCombo("cboYYInfPos2","","");
		Common_SetCombo("cboYYInfPos3","","");
		$("#dtFirInf").datebox('setValue',"");
		Common_SetLookup("cboYYBacteria11","","");
		Common_SetLookup("cboYYBacteria12","","");
		Common_SetLookup("cboYYBacteria13","","");
		Common_SetLookup("cboYYBacteria21","","");
		Common_SetLookup("cboYYBacteria22","","");
		Common_SetLookup("cboYYBacteria23","","");
		Common_SetLookup("cboYYBacteria31","","");
		Common_SetLookup("cboYYBacteria32","","");
		Common_SetLookup("cboYYBacteria33","","");
		Common_SetCombo("cboSQInfPos1","","");
		Common_SetCombo("cboSQInfPos2","","");
		Common_SetCombo("cboSQInfPos3","","");
		Common_SetCombo("cboSQMethod1","","");
		Common_SetCombo("cboSQMethod2","","");
		Common_SetCombo("cboSQMethod3","","");
		Common_SetLookup("cboSQBacteria11","","");
		Common_SetLookup("cboSQBacteria12","","");
		Common_SetLookup("cboSQBacteria13","","");
		Common_SetLookup("cboSQBacteria21","","");
		Common_SetLookup("cboSQBacteria22","","");
		Common_SetLookup("cboSQBacteria23","","");
		Common_SetLookup("cboSQBacteria31","","");
		Common_SetLookup("cboSQBacteria32","","");
		Common_SetLookup("cboSQBacteria33","","");
		//add by chenjb 20221114 cboCSSOperLung 术后手术 
		$('#cboCSSOperLung').combobox('disable');
		Common_SetCombo("cboCSSOperLung","","");
	}else if((DicDesc=="医院感染")){
		$("#dtFirInf").datebox('enable');
		$('#cboYYInfPos1').combobox('enable');
		$('#cboYYInfPos2').combobox('enable');
		$('#cboYYInfPos3').combobox('enable');
		$('.YYBacteria').lookup('enable');
		$('#cboCSSOperLung').combobox('enable');
		$('#cboSQInfPos1').combobox('disable');
		$('#cboSQInfPos2').combobox('disable');
		$('#cboSQInfPos3').combobox('disable');
		$('#cboSQMethod1').combobox('disable');
		$('#cboSQMethod2').combobox('disable');
		$('#cboSQMethod3').combobox('disable');
		$('.SQBacteria').lookup('disable');
		Common_SetCombo("cboYYInfPos1","","");
		Common_SetCombo("cboYYInfPos2","","");
		Common_SetCombo("cboYYInfPos3","","");
		$("#dtFirInf").datebox('setValue',"");
		Common_SetLookup("cboYYBacteria11","","");
		Common_SetLookup("cboYYBacteria12","","");
		Common_SetLookup("cboYYBacteria13","","");
		Common_SetLookup("cboYYBacteria21","","");
		Common_SetLookup("cboYYBacteria22","","");
		Common_SetLookup("cboYYBacteria23","","");
		Common_SetLookup("cboYYBacteria31","","");
		Common_SetLookup("cboYYBacteria32","","");
		Common_SetLookup("cboYYBacteria33","","");
		Common_SetCombo("cboSQInfPos1","","");
		Common_SetCombo("cboSQInfPos2","","");
		Common_SetCombo("cboSQInfPos3","","");
		Common_SetCombo("cboSQMethod1","","");
		Common_SetCombo("cboSQMethod2","","");
		Common_SetCombo("cboSQMethod3","","");
		Common_SetLookup("cboSQBacteria11","","");
		Common_SetLookup("cboSQBacteria12","","");
		Common_SetLookup("cboSQBacteria13","","");
		Common_SetLookup("cboSQBacteria21","","");
		Common_SetLookup("cboSQBacteria22","","");
		Common_SetLookup("cboSQBacteria23","","");
		Common_SetLookup("cboSQBacteria31","","");
		Common_SetLookup("cboSQBacteria32","","");
		Common_SetLookup("cboSQBacteria33","","");
		$('#cboCSSOperLung').combobox('enable');
		Common_SetCombo("cboCSSOperLung","","");
	}else if((DicDesc=="医院+社区")){
		$("#dtFirInf").datebox('enable');
		$('#cboYYInfPos1').combobox('enable');
		$('#cboYYInfPos2').combobox('enable');
		$('#cboYYInfPos3').combobox('enable');
		$('.YYBacteria').lookup('enable');
		$('#cboCSSOperLung').combobox('enable');
		$('#cboSQInfPos1').combobox('enable');
		$('#cboSQInfPos2').combobox('enable');
		$('#cboSQInfPos3').combobox('enable');
		$('#cboSQMethod1').combobox('enable');
		$('#cboSQMethod2').combobox('enable');
		$('#cboSQMethod3').combobox('enable');
		$('.SQBacteria').lookup('enable');
		Common_SetCombo("cboYYInfPos1","","");
		Common_SetCombo("cboYYInfPos2","","");
		Common_SetCombo("cboYYInfPos3","","");
		$("#dtFirInf").datebox('setValue',"");
		Common_SetLookup("cboYYBacteria11","","");
		Common_SetLookup("cboYYBacteria12","","");
		Common_SetLookup("cboYYBacteria13","","");
		Common_SetLookup("cboYYBacteria21","","");
		Common_SetLookup("cboYYBacteria22","","");
		Common_SetLookup("cboYYBacteria23","","");
		Common_SetLookup("cboYYBacteria31","","");
		Common_SetLookup("cboYYBacteria32","","");
		Common_SetLookup("cboYYBacteria33","","");
		Common_SetCombo("cboSQInfPos1","","");
		Common_SetCombo("cboSQInfPos2","","");
		Common_SetCombo("cboSQInfPos3","","");
		Common_SetCombo("cboSQMethod1","","");
		Common_SetCombo("cboSQMethod2","","");
		Common_SetCombo("cboSQMethod3","","");
		Common_SetLookup("cboSQBacteria11","","");
		Common_SetLookup("cboSQBacteria12","","");
		Common_SetLookup("cboSQBacteria13","","");
		Common_SetLookup("cboSQBacteria21","","");
		Common_SetLookup("cboSQBacteria22","","");
		Common_SetLookup("cboSQBacteria23","","");
		Common_SetLookup("cboSQBacteria31","","");
		Common_SetLookup("cboSQBacteria32","","");
		Common_SetLookup("cboSQBacteria33","","");
		$('#cboCSSOperLung').combobox('enable');
		Common_SetCombo("cboCSSOperLung","","");
	}else{
		$("#dtFirInf").datebox('disable');
		$('#cboYYInfPos1').combobox('disable');
		$('#cboYYInfPos2').combobox('disable');
		$('#cboYYInfPos3').combobox('disable');
		$('.YYBacteria').lookup('disable');
		$('#cboCSSOperLung').combobox('disable');
		$('#cboSQInfPos1').combobox('disable');
		$('#cboSQInfPos2').combobox('disable');
		$('#cboSQInfPos3').combobox('disable');
		$('#cboSQMethod1').combobox('disable');
		$('#cboSQMethod2').combobox('disable');
		$('#cboSQMethod3').combobox('disable');
		$('.SQBacteria').lookup('disable');
		Common_SetCombo("cboYYInfPos1","","");
		Common_SetCombo("cboYYInfPos2","","");
		Common_SetCombo("cboYYInfPos3","","");
		$("#dtFirInf").datebox('setValue',"");
		Common_SetLookup("cboYYBacteria11","","");
		Common_SetLookup("cboYYBacteria12","","");
		Common_SetLookup("cboYYBacteria13","","");
		Common_SetLookup("cboYYBacteria21","","");
		Common_SetLookup("cboYYBacteria22","","");
		Common_SetLookup("cboYYBacteria23","","");
		Common_SetLookup("cboYYBacteria31","","");
		Common_SetLookup("cboYYBacteria32","","");
		Common_SetLookup("cboYYBacteria33","","");
		Common_SetCombo("cboSQInfPos1","","");
		Common_SetCombo("cboSQInfPos2","","");
		Common_SetCombo("cboSQInfPos3","","");
		Common_SetCombo("cboSQMethod1","","");
		Common_SetCombo("cboSQMethod2","","");
		Common_SetCombo("cboSQMethod3","","");
		Common_SetLookup("cboSQBacteria11","","");
		Common_SetLookup("cboSQBacteria12","","");
		Common_SetLookup("cboSQBacteria13","","");
		Common_SetLookup("cboSQBacteria21","","");
		Common_SetLookup("cboSQBacteria22","","");
		Common_SetLookup("cboSQBacteria23","","");
		Common_SetLookup("cboSQBacteria31","","");
		Common_SetLookup("cboSQBacteria32","","");
		Common_SetLookup("cboSQBacteria33","","");
		$('#cboCSSOperLung').combobox('disable');
		Common_SetCombo("cboCSSOperLung","","");
	}
}
