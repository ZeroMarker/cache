var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_ER=String.fromCharCode(13)+String.fromCharCode(10);
var separete="&nbsp;";
var PortalFlg=ExtTool.GetParam(window,"PortalFlg");
var FORM_STEP_WIDTH = 300 ;   //定义临床路径展现时的步骤宽度  px
var CareProvTp="";

var FORM_STEP_LIST = "";
var docErrorInfoSys = "";
var nurErrorInfoSys = "";
/*********************************************************************
/弹出页面的初始化
**********************************************************************/
function InitFormNewWin(){
	var obj = new Object();
	
	obj.PathWayID = PathWayID;
	obj.CPWID = CPWID;
	if ((!obj.PathWayID)&&(!obj.CPWID)) return;
	
	obj.MainPanel = new Ext.Panel({
		id : 'MainPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,frame : true
		,layout : 'fit'
	})
	obj.MainViewport = new Ext.Viewport({
		id : 'MainViewport'
		,layout : 'border'
		,renderTo : document.body
		,items:[
			obj.MainPanel
		]
	});
	window.returnValue="";
	var ShowCallBack = function(value){
		window.returnValue = value;
		window.close();
	}
	obj.objFormShow=FormShow(obj.MainPanel,ShowCallBack,NewPage,CPWID,PathWayID,OEOrderFlag,NEOrderFlag,OEOutOrderFlag,NEOutOrderFlag,ConsultFlag,NurseFlag,VarianceFlag);
	if (!obj.objFormShow) {
		window.close();
	}
	
	return obj;
}

/******************************************************************************
/writer: zhufei
/date  : 2010-12-22
/for   : 表单展现
/input : 表单权限控制(0-没权限,1-执行权限,2-撤销权限)
/        Container       : 显示表单的ext容器
/        ShowCallBack    : 回调函数
/        NewPage         : 新页面          0/1
/        CPWID           : 路径表单ID
/        PathWayID       : 实施路径ID
/        OEOrderFlag     : 医嘱标记        0/1
/        NEOrderFlag     : 护嘱标记        0/1
/        OEOutOrderFlag  : 门诊医嘱标记    0/1/2
/        NEOutOrderFlag  : 门诊护嘱标记    0/1/2
/        ConsultFlag     : 诊疗标记        0/1/2
/        NurseFlag       : 护理标记        0/1/2
/        VarianceFlag    : 变异记录        0/1/2
*******************************************************************************/
function FormShow(Container,ShowCallBack,NewPage,CPWID,PathWayID,OEOrderFlag,NEOrderFlag,OEOutOrderFlag,NEOutOrderFlag,ConsultFlag,NurseFlag,VarianceFlag){
	if ((!PathWayID)&&(!CPWID)) return;
	
	var obj = new Object();
	
	//alert("NewPage="+NewPage+",OEOrderFlag="+OEOrderFlag+",NEOrderFlag="+NEOrderFlag+",OEOutOrderFlag="+OEOutOrderFlag+",NEOutOrderFlag="+NEOutOrderFlag+",ConsultFlag="+ConsultFlag+",NurseFlag="+NurseFlag+",VarianceFlag="+VarianceFlag);
	
	//var FORM_PageMode=0;           //页面显示模式
	// 1: 主表单       //可下医嘱 并标记诊疗、护理的执行
	// 2: 标记执行     //可标记医嘱、诊疗、护理的执行
	// 3: 撤销记录     //可撤销医嘱、诊疗、护理的执行
	// 4: 维护时表单展现
	if (typeof FORM_PageMode == 'undefined') {FORM_PageMode=1} //Modified by wuqk 2012-05-10
	
	//var FORM_UserMode=0;           //用户模式  在dhccpw.formshow.csp中设置
	// 1: 医生         //可下医嘱 并标记或撤销诊疗、医嘱的执行 可填写变异
	// 2: 护士         //可标记或撤销护嘱、护理的执行 可填写变异
	// 0: 维护时表单展现 或者 患者表单展现
	if (typeof FORM_UserMode == 'undefined') {FORM_UserMode=0}
	if (FORM_UserMode == 1) {
		CareProvTp="D";
	} else if (FORM_UserMode == 2) {
		CareProvTp="N";
	} else {
		CareProvTp="";
	}
	/*
       OEOrderFlag     : 医嘱标记        0/1
       NEOrderFlag     : 护嘱标记        0/1
       OEOutOrderFlag  : 门诊医嘱标记    0/1/2
       NEOutOrderFlag  : 门诊护嘱标记    0/1/2
       ConsultFlag     : 诊疗标记        0/1/2
       NurseFlag       : 护理标记        0/1/2
       VarianceFlag    : 变异记录        0/1/2
	*/
	
	if (PathWayID) {
		var objPathWay=GetClinPathWay(PathWayID);
		if (!objPathWay) return;
		CPWID=objPathWay.CPWDR;
		var objCPW = GetClinPathWayDic(CPWID);
		if (!objCPW) return;
		var MRAdm=objPathWay.MRADMDR;
		var EpisodeID=GetEpisodeID(MRAdm);
		var objStep = GetCurrentStep(EpisodeID);
		var objPaadm=GetDHCPAADM(EpisodeID);
		if (!objPaadm) return;
		var objPerson=GetDHCPaPerson(objPaadm.PatientID);
		if (!objPerson) return;
		var Title = BuildTitle(objPerson,objStep);
		var objTitle = BuildTitleObject(objPerson,objStep,objCPW,objPathWay);
		
		//初始化标记  //可下医嘱 并标记诊疗、护理的执行
		//初始化时根据医嘱标记和护嘱标记，判断医生和护士的身份(FORM_UserMode)，不再变化
		                         
		if (FORM_UserMode==0){FORM_PageMode = 4;}  //非临床操作模式，仅展现表单
		//removed by wuqk 2012-05-10
		//else{FORM_PageMode = 1;}      //默认进入主表单页面
	} 
	else {
		var objCPW = GetClinPathWayDic(CPWID);
		if (!objCPW) return;
		var Title = "当前路径:"+objCPW.CPWDesc;
		var objTitle = BuildTitleObject("","",objCPW,"");
		
		//初始化标记
		FORM_PageMode = 4;                          //默认进入表单展现
	}
	
	var winTitle;                         //新窗口标记
	var selectItems="";                   //所选医嘱项目
	var winTitle = Title;                 //表单标题
	
	
	var serviceFormShow=ExtTool.StaticServerObject("web.DHCCPW.MRC.FormShow");
	
	//取所有步骤列表
	var xepsteps=serviceFormShow.BuildJsonEpSteps(PathWayID,CPWID);
	if (xepsteps=="") return null;
	var xepsteps=Ext.util.JSON.decode(xepsteps);      // stepid,stepdesc,iscurrstep
	
	//取当前步骤Id
	var stepindex=0;
	var CurrentShowStepid=0;
	var CurrentStepid=0;
	for (var indest=0;indest<xepsteps.length;indest++){
		if (xepsteps[indest].iscurrstep==1){
			CurrentShowStepid=xepsteps[indest].stepid;
			CurrentStepid=xepsteps[indest].stepid;
			stepindex=indest;
		}
	}
	if (PathWayID){
		if (CurrentShowStepid==0){
			CurrentShowStepid=xepsteps[xepsteps.length-1].stepid;
			for (var indest=0;indest<xepsteps.length;indest++){
				if (xepsteps[indest].isoverstep==1){
					CurrentShowStepid=xepsteps[indest].stepid;
				}
			}
		}
	}
	
	/*  removed by wuqk 2011-12-27*/
	// var xdata=GetFormData(PathWayID,CPWID,stepindex);
	// if (!xdata) return;
	
	//模板定义
	//var len = xdata.head.length;
	//var twidth = len*FORM_STEP_WIDTH + 120 + 'px';
	//'<table border="0" width="',twidth,'" class="diytable" cellspacing="1" cellpadding="0">',
	
	var tpl2=new Ext.XTemplate(
			'<table border="0" width="100%" height="100%" class="diytable" cellspacing="1" cellpadding="0">',
				'<thead><tr height="26px"><th width="50px" class="diytd1th">步骤</th><tpl for="head">',
					'<th width="',FORM_STEP_WIDTH,'px" class=',
						'<tpl if="this.isCurrentStep(stepid)">',
							' "diytd2th" ',
						'</tpl>',
						'<tpl if="!this.isCurrentStep(stepid)">',
							' "diytd1th" ',
						'</tpl>',
					'>{stepdesc}</th>',
				'</tpl></tr></thead>',
				
				'<tr><td class="diytd3">时间调整</td><tpl for="estimate">',
						'<td vAlign=top class=' ,
							'<tpl if="this.isCurrentStep(stepid)">',
								' "diytd2" ',
							'</tpl>',
							'<tpl if="!this.isCurrentStep(stepid)">',
								' "diytd1" ',
							'</tpl>',
						'>',
							'<table width="300px">',
								'<tr><td class="diytit" colspan="2">{title}</td></tr>',
								'<tpl for="estsub">',
									'<tr><td width="7%"><input type="checkbox"  name="{nameList}" id="{idList}/{subtitle}/{isStart}/{estTime}" value=""></td><td width="93%">{subtitle}</td></tr>',
								'</tpl>',
							'</table>',
						'</td>',
				'</tpl></tr>',
				
				'<tr><td class="diytd3">主要诊疗工作</td><tpl for="consult">',
					'<td vAlign=top class=' ,
						'<tpl if="this.isCurrentStep(stepid)">',
							' "diytd2" ',
						'</tpl>',
						'<tpl if="!this.isCurrentStep(stepid)">',
							' "diytd1" ',
						'</tpl>',
					'><table width="',FORM_STEP_WIDTH,'px">',
						'<tpl for="stepdata">',
							'<tr><td width="7%"><input type="checkbox" name="{stepsubcatname}" id="{stepsubcatid}" value="{stepsubcatid}"></td><td class="diytit" colspan="2" width="93%">{subtitle}</td></tr>',
							'<tpl for="subcatedata">',
								'<tr><td width="7%"><input type="checkbox"  name="{nameList}" id="{idList}" value="{idList}"></td><td width="93%">',
								'<tpl for="groupdata">',
									'<span id="{id}" ',
									'<tpl if="optional==0">',
										'<tpl if="impl==0">',
											'class="diytit2" ',
										'</tpl>',
										'<tpl if="impl==1">',
											'class="diytext2_exec" ',
										'</tpl>',
									'</tpl>',
									'<tpl if="optional==1">',
										'<tpl if="impl==0">',
											'class="diytit2_option" ',
										'</tpl>',
										'<tpl if="impl==1">',
											'class="diytext2_option_exec" ',
										'</tpl>',
									'</tpl>',
									'>{item}</span>{[xindex==xcount?"":"、"]}',
								'</tpl>',
								'</td></tr>',
							'</tpl>',
						'</tpl>',
					'</table></td>',
				'</tpl></tr>',	
				
				'<tr><td class="diytd3">重点医嘱</td><tpl for="order">',
					'<td vAlign=top class=' ,
						'<tpl if="this.isCurrentStep(stepid)">',
							' "diytd2" ',
						'</tpl>',
						'<tpl if="!this.isCurrentStep(stepid)">',
							' "diytd1" ',
						'</tpl>',
					'><table width="',FORM_STEP_WIDTH,'px">',
						'<tpl for="stepdata">',
							'<tr><td width="7%"><input type="checkbox" name="{stepsubcatname}" id="{stepsubcatid}" value="{stepsubcatid}"></td><td class="diytit" colspan="2" width="93%">{subtitle}</td></tr>',
							'<tpl for="subcatedata">',
								'<tr><td width="7%"><input type="checkbox" name="{nameList}" id="{idList}" value="{idList}"></td><td width="93%">',
								'<tpl for="groupdata">',
									'<span id="{id}" value="{item}"',
									'<tpl if="optional==0">',
										'<tpl if="impl==0">',
											'class="diytit2" ',
										'</tpl>',
										'<tpl if="impl==1">',
											'class="diytext2_exec" ',
										'</tpl>',
									'</tpl>',
									'<tpl if="optional==1">',
										'<tpl if="impl==0">',
											'class="diytit2_option" ',
										'</tpl>',
										'<tpl if="impl==1">',
											'class="diytext2_option_exec" ',
										'</tpl>',
									'</tpl>',
									'>{item}</span>{[xindex==xcount?"":"、"]}',
								'</tpl>',
								'</td></tr>',
							'</tpl>',
						'</tpl>',
					'</table></td>',
				'</tpl></tr>',
				
				'<tpl for="syndrome">',
					'<tr>',
						'<td class="diytd3">{desc}</td>',
						'<tpl for="step">',
							'<td vAlign=top class=' ,
							'<tpl if="this.isCurrentStep(stepid)">',
								' "diytd2" ',
							'</tpl>',
							'<tpl if="!this.isCurrentStep(stepid)">',
								' "diytd1" ',
							'</tpl>',
							'>',
								'<table width="',FORM_STEP_WIDTH,'px">',
								'<tpl for="stepdata">',
									'<tr><td width="7%"><input type="checkbox" name="{stepsubcatname}" id="{stepsubcatid}" value="{stepsubcatid}"></td><td class="diytit" colspan="2" width="93%">{subtitle}</td></tr>',
											'<tpl for="subcatedata">',
												'<tr><td width="7%"><input type="checkbox" name="{nameList}" id="{idList}" value="{idList}"></td><td width="93%">',
												'<tpl for="groupdata">',
													'<span id="{id}" value="{item}"',
													'<tpl if="optional==0">',
													'<tpl if="impl==0">',
															'class="diytit2" ',
														'</tpl>',
														'<tpl if="impl==1">',
															'class="diytext2_exec" ',
														'</tpl>',
													'</tpl>',
													'<tpl if="optional==1">',
														'<tpl if="impl==0">',
															'class="diytit2_option" ',
														'</tpl>',
														'<tpl if="impl==1">',
															'class="diytext2_option_exec" ',
														'</tpl>',
													'</tpl>',
													'>{item}</span>{[xindex==xcount?"":"、"]}',
												'</tpl>',
												'</td></tr>',
											'</tpl>',
								'</tpl>',
								'</table>',
							'</td>',
						'</tpl>',
					'</tr>',
				'</tpl>',
				
				'<tr><td class="diytd3">主要护理工作</td><tpl for="nursing">',
					'<td vAlign=top class=' ,
						'<tpl if="this.isCurrentStep(stepid)">',
							' "diytd2" ',
						'</tpl>',
						'<tpl if="!this.isCurrentStep(stepid)">',
							' "diytd1" ',
						'</tpl>',
					'><table width="',FORM_STEP_WIDTH,'px">',
						'<tpl for="stepdata">',
							'<tr><td width="7%"><input type="checkbox" name="{stepsubcatname}" id="{stepsubcatid}" value="{stepsubcatid}"></td><td class="diytit" colspan="2" width="93%">{subtitle}</td></tr>',
							'<tpl for="subcatedata">',
								'<tr><td width="7%"><input type="checkbox" name="{nameList}" id="{idList}" value="{idList}"></td><td width="93%">',
								'<tpl for="groupdata">',
									'<span id="{id}" ',
									'<tpl if="optional==0">',
										'<tpl if="impl==0">',
											'class="diytit2" ',
										'</tpl>',
										'<tpl if="impl==1">',
											'class="diytext2_exec" ',
										'</tpl>',
									'</tpl>',
									'<tpl if="optional==1">',
										'<tpl if="impl==0">',
											'class="diytit2_option" ',
										'</tpl>',
										'<tpl if="impl==1">',
											'class="diytext2_option_exec" ',
										'</tpl>',
									'</tpl>',
									'>{item}</span>{[xindex==xcount?"":"、"]}',
								'</tpl>',
								'</td></tr>',
							'</tpl>',
						'</tpl>',
					'</table></td>',
				'</tpl></tr>',
				
				'<tr><td class="diytd3">病情变异记录</td><tpl for="variance">',
					'<td vAlign=top class=' ,
						'<tpl if="this.isCurrentStep(stepid)">',
							' "diytd2" ',
						'</tpl>',
						'<tpl if="!this.isCurrentStep(stepid)">',
							' "diytd1" ',
						'</tpl>',
					'><table width="',FORM_STEP_WIDTH,'px">',
						'<tr><td width="100%">',
						'<input type="checkbox" name="CPW_VARNO_ITEM" id="{stepid}" value="{stepid}">&nbsp;撤销&nbsp;&nbsp;&nbsp;&nbsp;',
							'<input type="checkbox" name="CPW_VARYES_ITEM" id="{stepid}" value="{stepid}">&nbsp;添加，原因：',
						'</td></tr>',
						'<tpl for="stepdata">',
							'<tpl for="subcatedata">',
								'<tr></td><td width="100%">{itemnum}.{itemdesc}</td></tr>',
							'</tpl>',
						'</tpl>',
					'</table></td>',
				'</tpl></tr>',
				
				'<tr><td class="diytd3">护士签名</td><tpl for="nursesign">',
					'<td vAlign=top class=' ,
						'<tpl if="this.isCurrentStep(stepid)">',
							' "diytd2" ',
						'</tpl>',
						'<tpl if="!this.isCurrentStep(stepid)">',
							' "diytd1" ',
						'</tpl>',
					'><table width="',FORM_STEP_WIDTH,'px">',
						'<tr><td width="100%">',
							'<input type="checkbox" name="CPW_NURBTNNO_ITEM" id="{stepid}" value="{stepid}">&nbsp;撤销&nbsp;&nbsp;&nbsp;&nbsp;',
							'<input type="checkbox" name="CPW_NURBTNYES_ITEM" id="{stepid}" value="{stepid}">&nbsp;添加，签名：',
						'</td></tr>',
						'<tpl for="stepdata">',
							'<tpl for="subcatedata">',
								'<tr></td><td width="100%">{itemnum}.{itemdesc}</td></tr>',
							'</tpl>',
						'</tpl>',
					'</table></td>',
				'</tpl></tr>',
				
				'<tr><td class="diytd3">医师签名</td><tpl for="doctorsign">',
					'<td vAlign=top class=' ,
						'<tpl if="this.isCurrentStep(stepid)">',
							' "diytd2" ',
						'</tpl>',
						'<tpl if="!this.isCurrentStep(stepid)">',
							' "diytd1" ',
						'</tpl>',
					'><table width="',FORM_STEP_WIDTH,'px">',
						'<tr><td width="100%">',
							'<input type="checkbox" name="CPW_DOCBTNNO_ITEM" id="{stepid}" value="{stepid}">&nbsp;撤销&nbsp;&nbsp;&nbsp;&nbsp;',
							'<input type="checkbox" name="CPW_DOCBTNYES_ITEM" id="{stepid}" value="{stepid}">&nbsp;添加，签名：',
						'</td></tr>',
						'<tpl for="stepdata">',
							'<tpl for="subcatedata">',
								'<tr></td><td width="100%">{itemnum}.{itemdesc}</td></tr>',
							'</tpl>',
						'</tpl>',
					'</table></td>',
				'</tpl></tr>',
				
			'</table>',
			{
		        // XTemplate configuration:
		        compiled: true,
		        disableFormats: true,
		        // member functions:
		        isCurrentStep: function(stepid){
		            return stepid == CurrentStepid;
		        },
		        isImpl: function(impl){
		            return impl == "1";
		        }
	    	}
	);
	/*
						'<tr><td class="diytit" colspan="2">{subtitle}</td></tr>',
						'<tr><td class="diytit" colspan="2">{subtitle}</td></tr>',
						'<tr><td class="diytit" colspan="2">{subtitle}</td></tr>',
													'<input type="checkbox" name="CPW_VARNO_ITEM" id="{stepid}" value="{stepid}">&nbsp;撤销&nbsp;&nbsp;&nbsp;&nbsp;',

						*/
	/***********************************************************
	*显示表单
	***********************************************************/
	//var cpwfp = Ext.getCmp("cpwFormPanel");
	//if (cpwfp) Container.remove(cpwfp);
	
	
	/****--页面按钮 bbar -------begin */
	
	cboLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	cboLocStore = new Ext.data.Store({
		proxy: cboLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'PatientID'
		}, 
		[
			{name: 'PatientName', mapping: 'PatientName'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'PatStr', mapping: 'PatStr'}
		])
	});
	cboLoc = new Ext.form.ComboBox({
		id : 'cboLoc'
		,width : 100
		,store : cboLocStore
		,minChars : 1
		,displayField : 'PatientName'
		,fieldLabel : '科室入径患者列表'
		,editable : false
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'PatStr'
		,listeners : {  
					'select':function(c,r,i){
						var cPatientID=c.getValue().split("^")[0]
						var cEpisodeID=c.getValue().split("^")[1]
						var cMRAdm=c.getValue().split("^")[2]
						var cPathWayID=c.getValue().split("^")[3]
						var lnk="dhccpw.mr.formshow.csp?a=a&ConsultFlag="+ConsultFlag+"&NurseFlag="+NurseFlag+"&OEOutOrderFlag="+OEOutOrderFlag+"&NEOutOrderFlag="+NEOutOrderFlag+"&VarianceFlag="+VarianceFlag+"&PatientID="+cPatientID+"&EpisodeID="+cEpisodeID+"&mradm="+cMRAdm+"&PathWayID="+cPathWayID+"&b=b";
						document.location.href=lnk;
					}
			 }
	});
	cboLocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.FormShow';
			param.QueryName = 'QryCurrLocCPWPat';
			var UserType="D";
			param.Arg1 = session['LOGON.CTLOCID'];
			if (NurseFlag==1)
			{
				UserType="N";
				param.Arg1 = session['LOGON.WARDID'];
			}
			param.Arg2 = UserType;
			
			param.ArgCnt = 2;
	});
	
	var btnNotFinish = new Ext.Toolbar.Item({
		tooltip: '必选项目未执行'
		,id: 'btnNotFinish'
		,html : "<img title='必选项目未执行' SRC='../scripts/dhccpw/img/notfinish.gif'>"
	});
	
	var tbar,tbar2;
	if (FORM_PageMode==4) {
		//tbar=['-',btnNotFinish,'-',winTitle,'-'];
		tbar=['-',btnNotFinish,'-',objTitle.RegNo,objTitle.PatName,objTitle.PatSex,objTitle.PatAge,objTitle.AdmDateTime,objTitle.AdmDoc,objTitle.CPWDesc,objTitle.InDateTime,objTitle.InDoctorDesc]; //,'<b>入径患者:</b>',cboLoc
	} else {
		var btnPageMainForm = new Ext.Toolbar.Button({
			tooltip: '主表单'
			,id: 'btnPageMainForm'
			,text : "<img title='主表单' SRC='../scripts/dhccpw/img/mainform.png'>"
			,handler: function (){
				obj.formShowData(1,0);
			}
		});
		
		var btnPageExeForm = new Ext.Toolbar.Button({
			tooltip: '标记执行'
			,id: 'btnPageExeForm'
			,text : "<img title='标记执行' SRC='../scripts/dhccpw/img/exeform.png'>"
			,handler: function (){
				obj.formShowData(2,0);
			}
		});
		
		var btnPageUndoForm = new Ext.Toolbar.Button({
			tooltip: '撤销记录'
			,id: 'btnPageUndoForm'
			,text : "<img title='撤销记录' SRC='../scripts/dhccpw/img/undoform.png'>"
			,handler: function (){
				obj.formShowData(3,0);
			}
		});
		
		var btnPageMRCPW = new Ext.Toolbar.Button({
			tooltip: '出入径'
			,id: 'btnPageMRCPW'
			,text : "<img title='出入径' SRC='../scripts/dhccpw/img/group.png'>"
			,handler: function (){
				var lnk="dhccpw.mr.clinpathway.csp?a=a&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+MRAdm+"&BackPage=1&b=b";
				document.location.href=lnk;
			}
		});
		
		var stepArray = new Array();
		for ( var i=0 ; i < xepsteps.length ; i++ ) {
			step = xepsteps[i];
			stepArray[i]=[step.stepid,step.stepdesc]
		}
		
		var combStepList = new Ext.form.ComboBox({
			id : 'combStepList'
			,store : new Ext.data.ArrayStore({id: 0,fields:['id','desc'],data:stepArray})
			,mode: 'local'
			,fieldLabel: '步骤列表'
			,forceSelection:true
			,displayField : 'desc'
			,editable : false
			,triggerAction : 'all'
			//,anchor : '95%'
			,width : 130
			,valueField : 'id'
			,value : CurrentShowStepid
			,listeners : {  
					'select':function(c,r,i){
						//alert(c.getValue());
						obj.formShowData(1,c.getValue());
					}
			 }
		});

		//modify by mxp 2017-09-27 头信息内容较多,个别电脑显示不全,分行显示
		tbar= new Ext.Toolbar({
	  		items: ['-',objTitle.RegNo,objTitle.PatName,objTitle.PatSex,objTitle.PatAge,objTitle.AdmDateTime,objTitle.AdmDoc,objTitle.CPWDesc,objTitle.InDateTime,objTitle.InDoctorDesc]
	  	});
		tbar2= new Ext.Toolbar({
	  		//items: ['-',btnPageMainForm,'',btnPageExeForm,'',btnPageUndoForm,'',btnPageMRCPW,'-',combStepList,'-',btnNotFinish,'-',winTitle]
	  		items: ['-',btnPageMainForm,'',btnPageExeForm,'',btnPageUndoForm,'',btnPageMRCPW,'-',combStepList,'-',btnNotFinish,'-','<b>入径患者:</b>',cboLoc]
	  	});
	  
	}
	/****--页面按钮 bbar -------end */
	
	
	
	/****--功能按钮 bbar -------begin */
	var btnEditSteps = new Ext.Toolbar.Button({
		tooltip: '调整步骤'
		,iconCls: 'icon-maintain'
		,text:'调整步骤'
		,id: 'btnEditSteps'
		,handler: function (){
			//var objCPW = GetClinPathWayDic(CPWID);
			if (objCPW.IsOffShoot=='Yes')
			{
				var winTitle="分支型路径【" + objCPW.CPWDesc + "】诊疗步骤及合并症调整：";
			}else{
				var winTitle="非分支型路径【" + objCPW.CPWDesc + "】合并症调整：";
			}
			InitEpStepWindowHeader(PathWayID,session['LOGON.USERID'],winTitle,objCPW.IsOffShoot);
		}
	});
	var btnExecEntry = new Ext.Toolbar.Button({
		tooltip: '执行'
		,iconCls: 'icon-add'
		,text:'执行'
		,id: 'btnExecEntry'
		,handler: function (){
			onExecEntryClick();
		}
	});
	var btnCPWVerHelp = new Ext.Toolbar.Button({
		tooltip: '帮助文档'
		,iconCls: 'icon-help' 
		,text:'帮助文档'
		,id : 'btnCPWVerHelp'
		,handler: function(){
			var objcpw = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysSrv");
			var verHelp=objcpw.GetHelpById(CPWID);
			if (!verHelp) return;
			//*******	Modified by zhaoyu 2012-11-26 基础信息维护-路径表单维护-【文档】中设置了字体倾斜和加粗后，在医生查看的帮助文档中无效 169
			var verHelpRepl = verHelp;
			while(verHelpRepl.indexOf("<STRONG>")>0){
				verHelpRepl = verHelpRepl.replace("<STRONG>","<b>");
			}
			while(verHelpRepl.indexOf("</STRONG>")>0){
				verHelpRepl = verHelpRepl.replace("</STRONG>","</b>");
			}
			while(verHelpRepl.indexOf("<EM>")>0){
				verHelpRepl = verHelpRepl.replace("<EM>","<i>");
			}
			while(verHelpRepl.indexOf("</EM>")>0){
				verHelpRepl = verHelpRepl.replace("</EM>","</i>");
			}
			//*******
			var tplHelpDocData={
				//verHelp:verHelp
				verHelpRepl:verHelpRepl	//	Modified by zhaoyu 2012-11-26 基础信息维护-路径表单维护-【文档】中设置了字体倾斜和加粗后，在医生查看的帮助文档中无效 169
			};
			//update by zf 2014-12-24 IE11帮助文件按钮不显示内容
			var helpDocumentPanel = Ext.getCmp('helpDocumentPanel');
			if (!helpDocumentPanel){
				helpDocumentPanel = new Ext.Panel({
					id : 'helpDocumentPanel'
					,layout : 'fit'
					,modal : true
					,renderTo : Ext.getBody()
					,autoScroll:true
				});
			}
			var tplHelpDoc=new Ext.XTemplate(
				'<table border=.1 width=100%>',
					'<tr>',
						//'<td bgcolor="#FFFFFF" >{verHelp}</td>',
						'<td bgcolor="#FFFFFF" >{verHelpRepl}</td>',	//	Modified by zhaoyu 2012-11-26 基础信息维护-路径表单维护-【文档】中设置了字体倾斜和加粗后，在医生查看的帮助文档中无效 169
					'</tr>',
				'</table>'
			);
			winHelp = new Ext.Window({
				id : 'winHelp'
				,height : 500
				,buttonAlign : 'center'
				,width : 680
				,layout : 'fit'
				,modal : true
				,title : '帮助信息'
				,items:[
			        helpDocumentPanel
		    	]
			});
			tplHelpDoc.compile();
			tplHelpDoc.overwrite(helpDocumentPanel.body,tplHelpDocData);
			winHelp.show();
		}
	});
	
	var btnOutPath = new Ext.Toolbar.Button({
		tooltip: '出径'
		,iconCls: 'icon-cancel'
		,text:'出径'
		,id: 'btnOutPath'
		,handler: function (){
			var objParent=Ext.getCmp('mainPanel');   //mainPanel  cpwFormPanel
			OutPathWayHeader(objParent,PathWayID,session['LOGON.USERID']);
		}
	});
	
	//add by mxp 2016-12-07 统一签名
	var btnAllSign = new Ext.Toolbar.Button({
		tooltip: '统一签名'
		,iconCls: 'icon-update'
		,text:'统一签名'
		,id: 'btnAllSign'
		,handler: function (){
			var winTitleSub="统一签名并处理变异";
			onSignAllClick(winTitleSub,CareProvTp);
		}
	});
	
	//增加完成路径按钮
	var btnClosePath = new Ext.Toolbar.Button({
		tooltip: '完成'
		,iconCls: 'icon-update'
		,text:'完成'
		,id: 'btnClosePath'
		,handler: function (){
			//add by zf 2012-12-06
			//处理签名步骤项目权限(签名后不允许操作)
			/*for (var stepIndex = 0; stepIndex < FORM_STEP_LIST.length; stepIndex++) {
				var objStepTMP = FORM_STEP_LIST[stepIndex];
				if (!objStepTMP) continue;
				
				if (!objStepTMP.isDocSignStep) {
					ExtTool.alert("提示","未完成步骤签名，不允许结束（完成）路径!");
					return;
				}
			}*/
			var objInterfaceCls = ExtTool.StaticServerObject("web.DHCCPW.MR.Interface");
			var docSignRet = objInterfaceCls.CheckSignBeforeDischarge("", EpisodeID, "1");
			var nurSignRet = objInterfaceCls.CheckSignBeforeDischarge("", EpisodeID, "2");
			var docSignArr = docSignRet.split(CHR_1);
			var nurSignArr = nurSignRet.split(CHR_1);
			var tipSignStr = "";
			if (docSignArr[0]=="Y" || docSignArr[0]=="N") {
				if (docSignArr[1]) {
					tipSignStr = tipSignStr + "[医生]" + docSignArr[1] + "\n";
				}
			}
			if (nurSignArr[0]=="Y" || nurSignArr[0]=="N") {
				if (nurSignArr[1]) {
					tipSignStr = tipSignStr + "[护士]" + nurSignArr[1] + "";
				}
			}
			if (tipSignStr!="") { alert(tipSignStr); }
			if (docSignArr[0]=="Y" || nurSignArr[0]=="Y") { return; }
			
			Ext.MessageBox.confirm('Confirm', '确定是否要结束（完成）路径?', function(btn,text){
				if(btn=="yes"){
					try{
						var objInterfaceCls = ExtTool.StaticServerObject("web.DHCCPW.MR.Interface");
						var ret = objInterfaceCls.ClosePathWay(EpisodeID);
						if(parseInt(ret) < 1) {
							ExtTool.alert("提示","结束路径失败!");
							return;
						}else{
							window.location.reload();
						}
					}catch(err){
						ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
					}
					return;
				}
			});
		}
	});
	
	// Add by zhaoyu 2014-07-03 合并症、并发症
	var btnSyndPathWay = new Ext.Toolbar.Button({
		tooltip : '添加合并症、并发症'
		,iconCls : 'icon-add'
		,text : '合并症、并发症'
		,id : 'btnSyndPathWay'
		,handler : function () {
			var objParent = Ext.getCmp('mainPanel');
			PathWaySyndHeader(objParent, PathWayID, session['LOGON.USERID']);
		}
	});
	
	var btnRstPathWay = new Ext.Toolbar.Button({
		tooltip: '出径或完成路径评估'
		,iconCls: 'icon-evaluate'
		,text:'评估'
		,id: 'btnRstPathWay'
		,handler: function (){
			var objParent=Ext.getCmp('mainPanel');
			//PathWayRstHeader(objParent,PathWayID,session['LOGON.USERID']);
			//modify by wuqk 2011-09-26
			PathWayEvaHeader(objParent,PathWayID,session['LOGON.USERID']);
		}
	});
	var btnPrintPathWay = new Ext.Toolbar.Button({
		tooltip: '打印医师版临床路径表单'
		,iconCls: 'icon-print'
		,text:'打印'
		,id: 'btnPrintPathWay'
		,width : 80
		,handler: function (){
			PrintPathWayForm(PathWayID);
		}
	});
	
	var btnPrintFormToPatient = new Ext.Toolbar.Button({
		tooltip: '打印患者版临床路径告知单'
		,iconCls: 'icon-print'
		,text:'打印告知单'
		,id: 'btnPrintFormToPatient'
		,width : 80
		,handler: function (){
			PrintPathWayFormToPatient(objCPW,objPerson,objPaadm)
		}
	});
	
	if (FORM_PageMode==4){
		btnEditSteps.setVisible(false);      //步骤调整
		btnExecEntry.setVisible(false);      //执行
		btnRstPathWay.setVisible(false);     //评估
		btnOutPath.setVisible(false);        //出径
		btnClosePath.setVisible(false);      //完成
		btnPrintPathWay.setVisible(false);   //打印表单
		btnPrintFormToPatient.setVisible(false);   //打印患者表单
		btnSyndPathWay.setVisible(false);	// Add by zhaoyu 2014-07-03 合并症、并发症
		btnAllSign.setVisible(false);		//add by mxp 2016-12-07 统一签名
	} else {
		if (objPathWay.Status=='I'){
			
		} else {                       //出径或完成后不能操作
			btnEditSteps.setVisible(false);      //步骤调整
			btnExecEntry.setVisible(false);      //执行
			btnRstPathWay.setVisible(false);     //评估
			btnOutPath.setVisible(false);        //出径
			btnClosePath.setVisible(false);      //完成
			btnSyndPathWay.setVisible(false);	// Add by zhaoyu 2014-07-03 合并症、并发症
			btnAllSign.setVisible(false);		//add by mxp 2016-12-07 统一签名
		}
	}
	if (FORM_UserMode==2) {               //护理人员不做步骤调整和出径
		btnEditSteps.setVisible(false);      //步骤调整
		btnOutPath.setVisible(false);        //出径
		btnClosePath.setVisible(false);      //完成
		btnSyndPathWay.setVisible(false);	// Add by zhaoyu 2014-07-03 合并症、并发症
	}
	/****--功能按钮 bbar -------end */
	
	
	var formPanel = new Ext.Panel({
		id : 'cpwFormPanel'
		,layout : 'fit'
		,region : 'center'
		,autoScroll:true
	});
	var panelItems;
	if (FORM_PageMode==4){
		panelItems=[formPanel];
	}
	else{
		//var orderEntryURL=BuildOrderEntryURL();
		formPanelOrderEntry = new Ext.Panel({
			id : 'formPanelOrderEntry'
			,layout : 'fit'
			,region : 'east'
			,width : screen.width-400
			,split: true
			,border: true
			,boxMinWidth: screen.width-400
			,boxMaxWidth: screen.width-100
			,html:"<iframe id='docOrderEntry' name='docOrderEntry' height='100%' width='100%' src='about:blank'/>"
		});
		panelItems=[formPanel,formPanelOrderEntry];
	}
	var mainPanel = new Ext.Panel({
		id : 'mainPanel'
		,buttonAlign : 'center'
		//,title : winTitle
		,frame : true
		,autoScroll:true
		,renderTo : document.body
		,items:panelItems
		,layout : 'border'
		,tbar:tbar
		,bbar : [
			"<i>相关操作:</i>"
			,'-'
			,btnCPWVerHelp     //帮助文档
			,btnEditSteps      //步骤调整
			,btnExecEntry      //执行
			,btnRstPathWay     //评估
			,btnOutPath        //出径      btnOutPathWay --> btnOutPath   避免与出径页面按钮重名 by wuqk 2011-12-28
			,btnPrintPathWay   //打印表单
			,btnPrintFormToPatient  //打印患者表单
			,btnClosePath      //完成路径（结束路径）
			,btnSyndPathWay	// Add by zhaoyu 2014-07-03 合并症、并发症
			,btnAllSign		//add by mxp 2016-12-07 统一签名
		]
		,listeners : {
			'render' : function(){
				if (tbar2) {
					tbar2.render(this.tbar);
				}
			}
		}
	})
	
	obj.onExecEntryClick = function() {
		onExecEntryClick();
	}
	
	obj.formShowData = function(pageMode,showStepId){
		if (pageMode==""){pageMode=FORM_PageMode}
		FORM_PageMode=pageMode;
		
		//doing.........
		//对初始化变量的判断
		//功能按钮
		//下医嘱页面
		if (FORM_PageMode==1){
			if (showStepId==0) {showStepId=CurrentShowStepid;}
			formPanelOrderEntry.setVisible(true);
			combStepList.setValue(showStepId);
			combStepList.setDisabled(false);
			
			//设置变量
			OEOutOrderFlag  =0;  //门诊医嘱标记    0/1/2
			NEOutOrderFlag  =0;  //门诊护嘱标记    0/1/2
			VarianceFlag    =1;  //变异记录        0/1/2
			if (FORM_UserMode==1){
				OEOrderFlag     =1;  //医嘱标记        0/1
				NEOrderFlag     =0;  //护嘱标记        0/1
				ConsultFlag     =1;  //诊疗标记        0/1/2
				NurseFlag       =0;  //护理标记        0/1/2
			}
			else if (FORM_UserMode==2){
				OEOrderFlag     =0;  //医嘱标记        0/1
				NEOrderFlag     =1;  //护嘱标记        0/1
				ConsultFlag     =0;  //诊疗标记        0/1/2
				NurseFlag       =1;  //护理标记        0/1/2
			}
			
		}
		else if (FORM_PageMode==2){
			formPanelOrderEntry.hide();
			combStepList.setValue("");
			combStepList.setDisabled(true);
			
			//设置变量
			VarianceFlag    =1;  //变异记录        0/1/2
			if (FORM_UserMode==1){
				OEOrderFlag     =0;  //医嘱标记        0/1
				NEOrderFlag     =0;  //护嘱标记        0/1
				OEOutOrderFlag  =1;  //门诊医嘱标记    0/1/2
				ConsultFlag     =1;  //诊疗标记        0/1/2
				NurseFlag       =0;  //护理标记        0/1/2
			}
			else if (FORM_UserMode==2){
				OEOrderFlag     =0;  //医嘱标记        0/1
				NEOrderFlag     =0;  //护嘱标记        0/1
				NEOutOrderFlag  =1;  //门诊护嘱标记    0/1/2
				ConsultFlag     =0;  //诊疗标记        0/1/2
				NurseFlag       =1;  //护理标记        0/1/2
			}
			
		}
		else if (FORM_PageMode==3){
			formPanelOrderEntry.hide();
			combStepList.setValue("");
			combStepList.setDisabled(true);
			
			//设置变量
			VarianceFlag    =1;  //变异记录        0/1/2
			if (FORM_UserMode==1){
				OEOrderFlag     =0;  //医嘱标记        0/1
				NEOrderFlag     =0;  //护嘱标记        0/1
				OEOutOrderFlag  =2;  //门诊医嘱标记    0/1/2
				ConsultFlag     =2;  //诊疗标记        0/1/2
				NurseFlag       =0;  //护理标记        0/1/2
			}
			else if (FORM_UserMode==2){
				OEOrderFlag     =0;  //医嘱标记        0/1
				NEOrderFlag     =0;  //护嘱标记        0/1
				NEOutOrderFlag  =2;  //门诊护嘱标记    0/1/2
				ConsultFlag     =0;  //诊疗标记        0/1/2
				NurseFlag       =2;  //护理标记        0/1/2
			}
		}
		else if (FORM_PageMode==4){
			OEOrderFlag     =0;  //医嘱标记        0/1
			NEOrderFlag     =0;  //护嘱标记        0/1
			OEOutOrderFlag  =0;  //门诊医嘱标记    0/1/2
			NEOutOrderFlag  =0;  //门诊护嘱标记    0/1/2
			ConsultFlag     =0;  //诊疗标记        0/1/2
			NurseFlag       =0;  //护理标记        0/1/2
			VarianceFlag    =0;  //变异记录        0/1/2
		}
		
		
		formPanel.setDisabled(true);
		var xdata=GetFormData(PathWayID,CPWID,showStepId);
		if (!xdata) return;
		
		//编译  加载
		tpl2.compile();
		try{
		tpl2.overwrite(formPanel.body,xdata);
			}catch(e){}
		formPanel.doLayout();
		mainPanel.doLayout();
		Container.doLayout();
		
		//loadEvent
		loadEvent();
		
		formPanel.setDisabled(false);
	}
	
	Container.add(mainPanel);
	obj.formShowData(FORM_PageMode,0);
	
	/***********************************************************
	*控制按钮，定义checkbox事件
	***********************************************************/
	function loadEvent(){
		//执行诊疗或门诊医嘱或下医嘱权限 + 入径状态 --> 调整步骤权限
		if ((ConsultFlag=="1")||(OEOutOrderFlag=="1")||(OEOrderFlag=="1")) {
			if ((objPathWay)&&(objCPW)){
				if ((objPathWay.Status=='I')&&(objCPW.IsOffShoot=='Yes')){
					//Ext.getCmp("btnEditSteps").setVisible(true);
					//初始调整步骤
					var objClinicalPathWays = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinicalPathWays");
					var IsTuneUpEpStep = objClinicalPathWays.IsTuneUpEpStep(PathWayID);
					if (IsTuneUpEpStep=="Y"){
						if (objCPW.IsOffShoot=='Yes')
						{
							var winTitle="分支型路径【" + objCPW.CPWDesc + "】诊疗步骤及合并症调整：";
						}else{
							var winTitle="非分支型路径【" + objCPW.CPWDesc + "】合并症调整：";
						}
						InitEpStepWindowHeader(PathWayID,session['LOGON.USERID'],winTitle,objCPW.IsOffShoot);
					}
				}
			}
		}
		
		/*  removed by wuqk 2011-12-28 功能按钮权限控制
		*/
		
		var CheckBoxPower="N";
		if (objPathWay){
			if (objPathWay.Status=='I'){
				CheckBoxPower="Y";
			}
		}
		if (CheckBoxPower=="N") {
			/*所有checkbox 都disabled*/
			var cpwItems=document.getElementsByTagName("input");{
				for (i=0;i<cpwItems.length;i++){
					var checkObj=cpwItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.disabled=true;
					}
				}
			}
		}else{
			//下医嘱+下护嘱+门诊医嘱
			if (OEOrderFlag=="1"){
				//为表单上的checkbox定义click事件
				var cpwOrdItems=document.getElementsByName("CPW_OE_ITEM");
				for (i=0;i<cpwOrdItems.length;i++){
					var checkObj=cpwOrdItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							var winTitleSub="下医嘱(医生)";
							onOrderClick(this,event,winTitleSub);
						}
					}
				}
				var cpwOrdItems=document.getElementsByName("CPW_OE_SELALL");
				for (i=0;i<cpwOrdItems.length;i++){
					var checkObj=cpwOrdItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							var winTitleSub="下医嘱(医生)";
							onSelectAllOrderClick(this,event,"CPW_OE_ITEM",winTitleSub);
						}
					}
				}
				Common_SetDisabledToChkItems('CPW_OE_ITEM',true,CurrentShowStepid,'0');
				Common_SetDisabledToChkCategs('CPW_OE_SELALL',true,CurrentShowStepid,'0');
			}else if (OEOutOrderFlag=="1"){
				//为表单上的checkbox定义click事件
				var cpwOrdItems=document.getElementsByName("CPW_OE_ITEM");
				for (i=0;i<cpwOrdItems.length;i++){
					var checkObj=cpwOrdItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							var winTitleSub="门诊(外院)医嘱";
							onOutOrderClick(this,event,winTitleSub);
						}
					}
				}
				Common_SetDisabledToChkCategs('CPW_OE_SELALL',true,'','');
			}else if (OEOutOrderFlag=="2"){
				//为表单上的checkbox定义click事件
				var cpwOrdItems=document.getElementsByName("CPW_OE_ITEM");
				for (i=0;i<cpwOrdItems.length;i++){
					var checkObj=cpwOrdItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							var winTitleSub="撤销门诊(外院)医嘱";
							onUpdoClick(this,event,winTitleSub);
						}
					}
				}
				Common_SetDisabledToChkCategs('CPW_OE_SELALL',true,'','');
			}else{
				Common_SetDisabledToChkItems('CPW_OE_ITEM',true,'','');
				Common_SetDisabledToChkCategs('CPW_OE_SELALL',true,'','');
			}
			
			if (NEOrderFlag=="1"){
				//为表单上的checkbox定义click事件
				var cpwOrdItems=document.getElementsByName("CPW_NE_ITEM");
				for (i=0;i<cpwOrdItems.length;i++){
					var checkObj=cpwOrdItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							var winTitleSub="下医嘱(护士)";
							onOrderClick(this,event,winTitleSub);
						}
					}
				}
				var cpwOrdItems=document.getElementsByName("CPW_NE_SELALL");
				for (i=0;i<cpwOrdItems.length;i++){
					var checkObj=cpwOrdItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							var winTitleSub="下医嘱(护士)";
							onSelectAllOrderClick(this,event,"CPW_NE_ITEM",winTitleSub);
						}
					}
				}
				Common_SetDisabledToChkItems('CPW_NE_ITEM',true,CurrentShowStepid,'0');
				Common_SetDisabledToChkCategs('CPW_NE_SELALL',true,CurrentShowStepid,'0');
			}else if (NEOutOrderFlag=="1"){
				//为表单上的checkbox定义click事件
				var cpwOrdItems=document.getElementsByName("CPW_NE_ITEM");
				for (i=0;i<cpwOrdItems.length;i++){
					var checkObj=cpwOrdItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							var winTitleSub="门诊(外院)护嘱";
							onOutOrderClick(this,event,winTitleSub);
						}
					}
				}
				Common_SetDisabledToChkCategs('CPW_NE_SELALL',true,'','');
			}else if (NEOutOrderFlag=="2"){
				//为表单上的checkbox定义click事件
				var cpwOrdItems=document.getElementsByName("CPW_NE_ITEM");
				for (i=0;i<cpwOrdItems.length;i++){
					var checkObj=cpwOrdItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							var winTitleSub="撤销门诊(外院)护嘱";
							onUpdoClick(this,event,winTitleSub);
						}
					}
				}
				Common_SetDisabledToChkCategs('CPW_NE_SELALL',true,'','');
			}else{
				Common_SetDisabledToChkItems('CPW_NE_ITEM',true,'','');
				Common_SetDisabledToChkCategs('CPW_NE_SELALL',true,'','');
			}
			
			//执行诊疗工作+撤销诊疗执行
			if (ConsultFlag=="1"){
				//为表单上的checkbox定义click事件
				var cpwConsultItems=document.getElementsByName("CPW_CONSULT_ITEM");
				for (i=0;i<cpwConsultItems.length;i++){
					var checkObj=cpwConsultItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							var winTitleSub="执行诊疗工作";
							onExecClick(this,event,winTitleSub);
						}
					}
				}
				var selConsultItems=document.getElementsByName("CPW_CONSULT_SELALL");
				for (i=0;i<selConsultItems.length;i++){
					var checkObj=selConsultItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							onSelectAllClick(this,event,"CPW_CONSULT_ITEM");
						}
					}
				}
			}else if (ConsultFlag=="2") {
				//为表单上的checkbox定义click事件
				var cpwConsultItems=document.getElementsByName("CPW_CONSULT_ITEM");
				for (i=0;i<cpwConsultItems.length;i++){
					var checkObj=cpwConsultItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							var winTitleSub="撤销诊疗记录";
							onUpdoClick(this,event,winTitleSub);
						}
					}
				}
				Common_SetDisabledToChkCategs('CPW_CONSULT_SELALL',true,'','');
			}else{
				Common_SetDisabledToChkItems('CPW_CONSULT_ITEM',true,'','');
				Common_SetDisabledToChkCategs('CPW_CONSULT_SELALL',true,'','');
			}
			
			//执行护理工作+撤销护理执行
			if (NurseFlag=="1"){
				//为表单上的checkbox定义click事件
				var cpwNurseItems=document.getElementsByName("CPW_NURSE_ITEM");
				for (i=0;i<cpwNurseItems.length;i++){
					var checkObj=cpwNurseItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							var winTitleSub="执行护理工作";
							onExecClick(this,event,winTitleSub);
						}
					}
				}
				var selNurseItems=document.getElementsByName("CPW_NURSE_SELALL");
				for (i=0;i<selNurseItems.length;i++){
					var checkObj=selNurseItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							onSelectAllClick(this,event,"CPW_NURSE_ITEM");
						}
					}
				}
			}else if (NurseFlag=="2") {
				//为表单上的checkbox定义click事件
				var cpwNurseItems=document.getElementsByName("CPW_NURSE_ITEM");
				for (i=0;i<cpwNurseItems.length;i++){
					var checkObj=cpwNurseItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							var winTitleSub="撤销护理记录";
							onUpdoClick(this,event,winTitleSub);
						}
					}
				}
				Common_SetDisabledToChkCategs('CPW_NURSE_SELALL',true,'','');
			}else{
				Common_SetDisabledToChkItems('CPW_NURSE_ITEM',true,'','');
				Common_SetDisabledToChkCategs('CPW_NURSE_SELALL',true,'','');
			}
			
			//调整时间时间,与执行诊疗权限相同
			if ((ConsultFlag=="1")||(OEOutOrderFlag=="1")||(OEOrderFlag=="1")){
				var cpwEstItems=document.getElementsByName("CPW_EST_ITEM");
				for (i=0;i<cpwEstItems.length;i++){
					var checkObj=cpwEstItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							var winTitleSub="调整实施路径步骤时间";
							onEstClick(this,event,winTitleSub);
						}
					}
				}
			}else{
				Common_SetDisabledToChkItems('CPW_EST_ITEM',true,'','');
			}
			
			//病情变异记录+删除变异记录
			if ((VarianceFlag=="1")||(VarianceFlag=="2")){
				var cpwVarianceItems=document.getElementsByName("CPW_VARYES_ITEM");
				for (i=0;i<cpwVarianceItems.length;i++){
					var checkObj=cpwVarianceItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							var winTitleSub="病情变异记录";
							onVarClick(this,event,winTitleSub,obj);
						}
					}
				}
				var cpwVarianceItems=document.getElementsByName("CPW_VARNO_ITEM");
				for (i=0;i<cpwVarianceItems.length;i++){
					var checkObj=cpwVarianceItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							var winTitleSub="删除变异记录";
							onUpdoVarClick(this,event,winTitleSub);
						}
					}
				}
			}else{
				Common_SetDisabledToChkItems('CPW_VARYES_ITEM',true,'','');
				Common_SetDisabledToChkItems('CPW_VARNO_ITEM',true,'','');
			}
			
			//医师签名+撤销签名
			if ((ConsultFlag=="1")||(ConsultFlag=="2")) {
				var cpwDoctorSignItems=document.getElementsByName("CPW_DOCBTNYES_ITEM");
				for (i=0;i<cpwDoctorSignItems.length;i++){
					var checkObj=cpwDoctorSignItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							var winTitleSub="医师签名";
							onDoctorSignClick(this,event,winTitleSub,"D");
						}
					}
				}
				var cpwDoctorSignItems=document.getElementsByName("CPW_DOCBTNNO_ITEM");
				for (i=0;i<cpwDoctorSignItems.length;i++){
					var checkObj=cpwDoctorSignItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							var winTitleSub="撤销医师签名";
							onUpdoSignClick(this,event,winTitleSub,"D");
						}
					}
				}
			}else{
				Common_SetDisabledToChkItems('CPW_DOCBTNYES_ITEM',true,'','');
				Common_SetDisabledToChkItems('CPW_DOCBTNNO_ITEM',true,'','');
			}
			
			//护士签名+撤销签名
			if ((NurseFlag=="1")||(NurseFlag=="2")){
				var cpwNurseSignItems=document.getElementsByName("CPW_NURBTNYES_ITEM");
				for (i=0;i<cpwNurseSignItems.length;i++){
					var checkObj=cpwNurseSignItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							var winTitleSub="护士签名";
							//modify by wuqk 2011-12-29
							//onNurseSignClick(this,event,winTitleSub,"N");
							onDoctorSignClick(this,event,winTitleSub,"N");

						}
					}
				}
				var cpwNurseSignItems=document.getElementsByName("CPW_NURBTNNO_ITEM");
				for (i=0;i<cpwNurseSignItems.length;i++){
					var checkObj=cpwNurseSignItems[i];
					if (checkObj.type=="checkbox"){
						checkObj.onclick=function(){
							var winTitleSub="撤销护士签名";
							onUpdoSignClick(this,event,winTitleSub,"N");
						}
					}
				}
			}else{
				Common_SetDisabledToChkItems('CPW_NURBTNYES_ITEM',true,'','');
				Common_SetDisabledToChkItems('CPW_NURBTNNO_ITEM',true,'','');
			}
			
			//add by zf 2012-12-06
			//处理签名步骤项目权限(签名后不允许操作)
			for (var stepIndex = 0; stepIndex < FORM_STEP_LIST.length; stepIndex++) {
				var objStepTMP = FORM_STEP_LIST[stepIndex];
				if (!objStepTMP) continue;
				
				if (objStepTMP.isDocSignStep) {
					Common_SetDisabledToChkItems('CPW_CONSULT_ITEM',true,objStepTMP.stepid,'1');
					Common_SetDisabledToChkItems('CPW_OE_ITEM',true,objStepTMP.stepid,'1');
					Common_SetDisabledToChkEsts('CPW_EST_ITEM',true,objStepTMP.stepid,'1');
					Common_SetDisabledToChkCategs('CPW_CONSULT_SELALL',true,objStepTMP.stepid,'1');
					Common_SetDisabledToChkCategs('CPW_OE_SELALL',true,objStepTMP.stepid,'1');
				}
				if (objStepTMP.isNurSignStep) {
					Common_SetDisabledToChkItems('CPW_NURSE_ITEM',true,objStepTMP.stepid,'1');
					Common_SetDisabledToChkItems('CPW_NE_ITEM',true,objStepTMP.stepid,'1');
					Common_SetDisabledToChkCategs('CPW_NURSE_SELALL',true,objStepTMP.stepid,'1');
					Common_SetDisabledToChkCategs('CPW_NE_SELALL',true,objStepTMP.stepid,'1');
				}
			}
			
			/*
			//判断已经过的步骤未签名,不允许操作后边的步骤
			var isDocNotSign = 1;
			var isNurNotSign = 1;
			var docErrorInfo = "";
			var nurErrorInfo = "";
			for (var stepIndex = 0; stepIndex < FORM_STEP_LIST.length; stepIndex++) {
				var objStepTMP = FORM_STEP_LIST[stepIndex];
				if (!objStepTMP) continue;
				
				if ((objStepTMP.isoverstep)&&(!objStepTMP.iscurrstep)&&(!objStepTMP.isDocSignStep)) {
					isDocNotSign = 0;
					docErrorInfo = docErrorInfo + "阶段【" + objStepTMP.stepdesc + "】未签名!<br>";
				}
				if ((objStepTMP.isoverstep)&&(!objStepTMP.iscurrstep)&&(!objStepTMP.isNurSignStep)) {
					isNurNotSign = 0;
					nurErrorInfo = nurErrorInfo + "阶段【" + objStepTMP.stepdesc + "】未签名!<br>";
				}
			}

			// add by zf 2012-12-06
			if (ConsultFlag == "1") {
				if ((docErrorInfoSys != docErrorInfo)&&(docErrorInfo != "")) {
					docErrorInfoSys = docErrorInfo;
					ExtTool.alert("提示",docErrorInfo + "请完成以上阶段的签名!");
				}
			}
			if (NurseFlag == "1") {
				if ((nurErrorInfoSys != nurErrorInfo)&&(nurErrorInfo != "")) {
					nurErrorInfoSys = nurErrorInfo;
					ExtTool.alert("提示",docErrorInfo + "请完成以上阶段的签名!");
				}
			}
			
			for (var stepIndex = 0; stepIndex < FORM_STEP_LIST.length; stepIndex++) {
				var objStepTMP = FORM_STEP_LIST[stepIndex];
				if (!objStepTMP) continue;
				
				if (((!objStepTMP.isoverstep)||(objStepTMP.iscurrstep))&&(!isDocNotSign)) {
					Common_SetDisabledToChkItems('CPW_CONSULT_ITEM',true,objStepTMP.stepid,'1');
					Common_SetDisabledToChkItems('CPW_OE_ITEM',true,objStepTMP.stepid,'1');
					Common_SetDisabledToChkEsts('CPW_EST_ITEM',true,objStepTMP.stepid,'1');
					Common_SetDisabledToChkCategs('CPW_CONSULT_SELALL',true,objStepTMP.stepid,'1');
					Common_SetDisabledToChkCategs('CPW_OE_SELALL',true,objStepTMP.stepid,'1');
				}
				if (((!objStepTMP.isoverstep)||(objStepTMP.iscurrstep))&&(!isNurNotSign)) {
					Common_SetDisabledToChkItems('CPW_NURSE_ITEM',true,objStepTMP.stepid,'1');
					Common_SetDisabledToChkItems('CPW_NE_ITEM',true,objStepTMP.stepid,'1');
					Common_SetDisabledToChkCategs('CPW_NURSE_SELALL',true,objStepTMP.stepid,'1');
					Common_SetDisabledToChkCategs('CPW_NE_SELALL',true,objStepTMP.stepid,'1');
				}
			}
			*/
			
			/* update by zf 2012-12-06
			var objSignSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysSign");
			var strSignSteps=objSignSrv.GetSignSteps(PathWayID);
			if (strSignSteps)
			{
				var tmpList=strSignSteps.split(",");
				var docSignList=tmpList[0].split("/");
				var nurSignList=tmpList[1].split("/");
				
				for (var signIndex=0;signIndex<docSignList.length ;signIndex++ )
				{
					var docSignStep=docSignList[signIndex];
					if (docSignStep=='') continue
					Common_SetDisabledToChkItems('CPW_CONSULT_ITEM',true,docSignStep,'1');
					Common_SetDisabledToChkItems('CPW_OE_ITEM',true,docSignStep,'1');
					Common_SetDisabledToChkEsts('CPW_EST_ITEM',true,docSignStep,'1');
					Common_SetDisabledToChkCategs('CPW_CONSULT_SELALL',true,docSignStep,'1');
					Common_SetDisabledToChkCategs('CPW_OE_SELALL',true,docSignStep,'1');
				}
				
				for (var signIndex=0;signIndex<nurSignList.length ;signIndex++ )
				{
					var nurSignStep=nurSignList[signIndex];
					if (nurSignStep=='') continue
					Common_SetDisabledToChkItems('CPW_NURSE_ITEM',true,nurSignStep,'1');
					Common_SetDisabledToChkItems('CPW_NE_ITEM',true,nurSignStep,'1');
					Common_SetDisabledToChkCategs('CPW_NURSE_SELALL',true,nurSignStep,'1');
					Common_SetDisabledToChkCategs('CPW_NE_SELALL',true,nurSignStep,'1');
				}
			}
			*/
		}
		
		//add by zf 2016-04-08 延迟加载医嘱录入页面
		setTimeout(function() {
				if (!document.getElementById('docOrderEntry')) return;
			var orderEntryURL=BuildOrderEntryURL();
			document.getElementById('docOrderEntry').src = orderEntryURL;
 		}, 1000);
	}
	
	//loadEvent();
	
	function onSelectAllOrderClick(objInp,evt,ItemName,winTitleSub){
		if (!objInp.id) return;

		//update by zf 20150617
		objInp.checked = false;
		var ItemID='';
		var StepID=objInp.id.split("-")[0];
		var SubCatID=objInp.id.split("-")[1];
		var win = new OE_InitOEOrder(EpisodeID,StepID,SubCatID,ItemID);
		win.OE_WinOEOrder.show();
		return;

		var winFlag=0;
		var rows=0,arcimCount=0;
		var tempItems="";
		var template = '<table>';
		var tmpList0=objInp.id.split("-");
		var currstepid=tmpList0[0];
		var currsubcatid=tmpList0[1];
		var curritemcpwid=tmpList0[2];
		var cpwConsultItems=document.getElementsByName(ItemName);
		for (i=0;i<cpwConsultItems.length;i++){
			var checkObj=cpwConsultItems[i];
			if (checkObj.type=="checkbox"){
				if (checkObj.id=="") continue;
				var StepRowid="";
				var tmpList00=checkObj.id.split(",");
				if (tmpList00.length>1){
					var tmpList1=tmpList00[0].split("-");
				}else{
					var tmpList1=checkObj.id.split("-");
				}
				if (tmpList1.length>2){
					var tmpList2=tmpList1[0].split("||");
					if (tmpList2.length>3){
						ItemCPWID=tmpList2[0];
					}
					StepRowid=tmpList1[1];
					SubCatRowid=tmpList1[2];
				}else{
					var tmpList2=tmpList1[0].split("||");
					if (tmpList2.length>3){
						ItemCPWID=tmpList2[0];
						StepRowid=tmpList2[0] +"||" + tmpList2[1] + "||" + tmpList2[2];
						SubCatRowid="";
					}
				}
				if ((StepRowid==currstepid)&&(SubCatRowid==currsubcatid)&&(curritemcpwid==ItemCPWID)){
					checkObj.disabled=objInp.checked;
					if (objInp.checked){
						var childrenItems=checkObj.parentElement.parentElement.getElementsByTagName("span");
						var childLen=childrenItems.length;
						for (var ind=0;ind<childLen;ind++){
							node=childrenItems[ind];
							var arrayArcim=GetItemACRIM(node.id);
							itemString = '<tr><td>';
							if (arrayArcim.length>=1){                   //包含一条或多条医嘱项
								itemString+=separete;
							}else{                                       //不包含医嘱项
								tempItems=node.id;
							}
							itemString+='</td>'
							itemString+='<td colspan="2">'
							itemString+=node.outerHTML;
							itemString+='</td></tr>';
							rows+=1;
							if (arrayArcim.length>=1){
								for (var indexAcrim=0;indexAcrim<arrayArcim.length;indexAcrim++){
									rows+=1;
									arcimCount++;
									var objItemArcim=arrayArcim[indexAcrim];
									itemString+='<tr><td>'+separete+'</td><td>';
									itemString+='<input type="checkbox" name="CHECK_ITEM" ';
									if ((objItemArcim.defaults=="Y")&&(objItemArcim.isOptional=="N")) itemString+=' checked ';
									itemString+=' id="'+node.id+'^'+objItemArcim.Index+'^'+objItemArcim.itmLinkNo+'" >';
									//update by zf 20120316 斜体显示不清楚
									//itemString+='<td><span><i>'+objItemArcim.arcimDesc+'</i></span></td>';
									itemString+='<td><span>'+objItemArcim.arcimDesc+'</span></td>';
									itemString+='</tr>';
								}
							}
							template+=itemString;
						}
					}
				}
			}
		}
		template+='</table>';
		if (arcimCount<1) {      //项目不包含医嘱，修改checkbox的value、checked
			objInp.value=tempItems;
			objInp.checked=false;
			return;
		}
		
		var winHeight=rows*30+85;
		var winWidth=400;
		var winX=evt.clientX;
		var winY=evt.clientY;
		
		var docClientHeight=document.body.clientHeight;
		if (winHeight>(docClientHeight-100))
		{
			winHeight=docClientHeight-100;
		}
		winHeight = winHeight + 20;
		if ((winY>(docClientHeight-winY))&&(winY>winHeight)) {
			winY=winY-winHeight;
		} else if (((docClientHeight-winY)>winY)&&((docClientHeight-winY)>winHeight)) {
			winY=winY;
		} else {
			winY=(docClientHeight-winHeight)/2;
		}
		
		var docClientWidth=document.body.clientWidth;
		if (winX>(docClientWidth-winX)) {
			if (winWidth>(winX-200)){
				winWidth=winX-200;
			}
			winX=winX-winWidth;
		} else {
			if (winWidth>(docClientWidth-winX-200)){
				winWidth=docClientWidth-winX-200;
			}
		}
		
		win = new Ext.Window({
				//id : 'win',   //by wuqk 2012-02-22
				width : 400,
				height : winHeight,
				x : winX,
				y : winY,     //removed by wuqk 2010-11-17
				resizable : false,
				closable : true,
				autoScroll:true,
				animCollapse : true,
				html:template,
				renderTo : document.body,
				layout : 'fit',
				modal : true,
				title : winTitleSub,
				bbar: ['-'
		        	,{
						xtype:"checkbox"
						,id : 'chkSelAllOE'
						,boxLabel:"全选\反选"
						,listeners:{
							'check': function(){
								var chkItems=document.getElementsByName("CHECK_ITEM");
								for (i=0;i<chkItems.length;i++){
									var checkObj=chkItems[i];
									if (checkObj.type=="checkbox"){
										checkObj.checked = Ext.getCmp('chkSelAllOE').checked;
									}
								}
							}
					    }
					},'-'
				],
				buttons : [{
					id : 'btnConfirm',
					text : '确定',
					iconCls : 'icon-confirm',
					listeners : {
						"click" : function(){
							var chkItems=document.getElementsByName("CHECK_ITEM");
							var idList="";
							for (i=0;i<chkItems.length;i++){
								var checkObj=chkItems[i];
								if (checkObj.type=="checkbox"){
									if (checkObj.checked) {
										idList+=checkObj.id+",";
									}
								}
							}
							if (idList==""){
								objInp.value="";
								objInp.checked=false;
							}else{
								objInp.checked=true;
								objInp.value=idList.substring(0,idList.length-1);
							}
							winFlag=1;
							win.close();
							onOrderEntryClick();   //add by wuqk 2011-12-28
						}
					}
				},{
					id : 'btnCancel',
					text : '取消',
					iconCls : 'icon-undo',
					listeners : {
						"click" : function(){
							objInp.value="";
							objInp.checked=false;
							var tmpList0=objInp.id.split("-");
							var currstepid=tmpList0[0];
							var currsubcatid=tmpList0[1];
							var curritemcpwid=tmpList0[2];
							var cpwConsultItems=document.getElementsByName(ItemName);
							for (i=0;i<cpwConsultItems.length;i++){
								var checkObj=cpwConsultItems[i];
								if (checkObj.type=="checkbox"){
									if (checkObj.id=="") continue;
									var StepRowid="";
									var tmpList00=checkObj.id.split(",");
									if (tmpList00.length>1){
										var tmpList1=tmpList00[0].split("-");
									}else{
										var tmpList1=checkObj.id.split("-");
									}
									if (tmpList1.length>2){
										var tmpList2=tmpList1[0].split("||");
										if (tmpList2.length>3){
											ItemCPWID=tmpList2[0];
										}
										StepRowid=tmpList1[1];
										SubCatRowid=tmpList1[2];
									}else{
										var tmpList2=tmpList1[0].split("||");
										if (tmpList2.length>3){
											ItemCPWID=tmpList2[0];
											StepRowid=tmpList2[0] +"||" + tmpList2[1] + "||" + tmpList2[2];
											SubCatRowid="";
										}
									}
									if ((StepRowid==currstepid)&&(SubCatRowid==currsubcatid)&&(curritemcpwid==ItemCPWID)){
										checkObj.disabled=false;
									}
								}
							}
							winFlag=1;
							win.close();
						}
					}
				}],
				listeners :{
					"beforeclose" : function(){
						if (winFlag=="0"){
							objInp.value="";
							objInp.checked=false;
							
							var tmpList0=objInp.id.split("-");
							var currstepid=tmpList0[0];
							var currsubcatid=tmpList0[1];
							var curritemcpwid=tmpList0[2];
							var cpwConsultItems=document.getElementsByName(ItemName);
							for (i=0;i<cpwConsultItems.length;i++){
								var checkObj=cpwConsultItems[i];
								if (checkObj.type=="checkbox"){
									if (checkObj.id=="") continue;
									var StepRowid="";
									var tmpList00=checkObj.id.split(",");
									if (tmpList00.length>1){
										var tmpList1=tmpList00[0].split("-");
									}else{
										var tmpList1=checkObj.id.split("-");
									}
									if (tmpList1.length>2){
										var tmpList2=tmpList1[0].split("||");
										if (tmpList2.length>3){
											ItemCPWID=tmpList2[0];
										}
										StepRowid=tmpList1[1];
										SubCatRowid=tmpList1[2];
									}else{
										var tmpList2=tmpList1[0].split("||");
										if (tmpList2.length>3){
											ItemCPWID=tmpList2[0];
											StepRowid=tmpList2[0] +"||" + tmpList2[1] + "||" + tmpList2[2];
											SubCatRowid="";
										}
									}
									if ((StepRowid==currstepid)&&(SubCatRowid==currsubcatid)&&(curritemcpwid==ItemCPWID)){
										checkObj.disabled=false;
									}
								}
							}
							
						}
					},
					'beforeshow' : function(){
						var chkItems=document.getElementsByName("CHECK_ITEM");
						for (var i=0;i<chkItems.length;i++){
							var checkObj=chkItems[i];
							if (checkObj.type=="checkbox"){
								checkObj.onclick=onArcimCheckClick;
							}
						}
					}
				}
		});
		win.show();
	}
	
	
	function onSelectAllClick(objInp,evt,ItemName){
		if (!objInp.id) return;
		
		var tmpList0=objInp.id.split("-");
		var currstepid=tmpList0[0];
		var currsubcatid=tmpList0[1];
		var curritemcpwid=tmpList0[2];
		var cpwConsultItems=document.getElementsByName(ItemName);
		for (i=0;i<cpwConsultItems.length;i++){
			var checkObj=cpwConsultItems[i];
			if (checkObj.type=="checkbox"){
				if (checkObj.id=="") continue;
				var StepRowid="";
				var tmpList00=checkObj.id.split(",");
				if (tmpList00.length>1){
					var tmpList1=tmpList00[0].split("-");
				}else{
					var tmpList1=checkObj.id.split("-");
				}
				if (tmpList1.length>2){
					var tmpList2=tmpList1[0].split("||");
					if (tmpList2.length>3){
						ItemCPWID=tmpList2[0];
					}
					StepRowid=tmpList1[1];
					SubCatRowid=tmpList1[2];
				}else{
					var tmpList2=tmpList1[0].split("||");
					if (tmpList2.length>3){
						ItemCPWID=tmpList2[0];
						StepRowid=tmpList2[0] +"||" + tmpList2[1] + "||" + tmpList2[2];
						SubCatRowid="";
					}
				}
				if ((StepRowid==currstepid)&&(SubCatRowid==currsubcatid)&&(curritemcpwid==ItemCPWID)){
					checkObj.checked=objInp.checked;
				}
			}
		}
	}
	
	function updateVariance(VarEpStep,VarCateg,VarReason,VarResume){
		var InputErr="";
		var VarID="",VarEp="",VarUserID="",VarDate="",VarTime="",VarDoctorID="";
		
		if ((!VarEpStep)||(!VarCateg)||(!VarReason)||(!EpisodeID)||(!PathWayID))  return false;
		
		if (!VarEpStep){
			InputErr = InputErr + "路径步骤为空,请认真填写!" + CHR_ER;
		}
		if (!VarCateg){
			InputErr = InputErr + "变异类型为空,请认真填写!" + CHR_ER;
		}
		if (!VarReason){
			InputErr = InputErr + "变异原因为空,请认真填写!" + CHR_ER;
		}
		
		if (InputErr) {
			ExtTool.alert("提示",InputErr);
			return false;
		}
		
		VarID=PathWayID;
		VarUserID=session['LOGON.USERID'];
		VarDate="";
		VarTime="";
		var objCTCareProvSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.CTCareProvSrv");
		var strDoctor=objCTCareProvSrv.GetCareProvByUserID(VarUserID);
		VarDoctorID=strDoctor.split("^")[0];
		
		var InputStr=VarID;
		InputStr=InputStr + "^" + VarEp;
		InputStr=InputStr + "^" + VarCateg;
		InputStr=InputStr + "^" + VarReason;
		InputStr=InputStr + "^" + VarUserID;
		InputStr=InputStr + "^" + VarDate;
		InputStr=InputStr + "^" + VarTime;
		InputStr=InputStr + "^" + VarDoctorID;
		InputStr=InputStr + "^" + VarResume;
		InputStr=InputStr + "^" + VarEpStep;
		var objMRClinicalPathWays = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysVariance");
		var ret = objMRClinicalPathWays.Update(InputStr);
		if (ret<0){
			ExtTool.alert("提示","更新失败!");
			return false;
		} else {
			/*
			////loaddata-wuqk  --填写变异后刷新--
			var xdata=GetFormData(PathWayID,CPWID);
			tpl2.compile();
			tpl2.overwrite(formPanel.body,xdata);
			formPanel.doLayout();
			Container.doLayout();
			loadEvent();*/
			obj.formShowData(FORM_PageMode,0);
			return true;
		}
	}
	
	function updoVariance(IDList){
		var objVarianceSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysVariance");
		for (var i=0;i<IDList.length;i++){
			var VarID=IDList[i];
			var InputStr = VarID + "^" + session['LOGON.USERID'];
			var flg=objVarianceSrv.UpdoVariance(InputStr);
		}
		
		/*
			////loaddata-wuqk  --撤销变异后刷新--
		var xdata=GetFormData(PathWayID,CPWID);
		tpl2.compile();
		tpl2.overwrite(formPanel.body,xdata);
		formPanel.doLayout();
		Container.doLayout();
		loadEvent();*/
		
		obj.formShowData(FORM_PageMode,0);
		return true;
	}
	
	//弹出病情变异记录事件
	function onVarClick(objInp,evt,winTitleSub,obj){
		if (!objInp.checked) return;
		
		var winFlag=0;
		
		var winHeight=500;
		var winWidth=600;
		var winX=evt.clientX;
		var winY=evt.clientY;
				
		var docClientHeight=document.body.clientHeight;
		if (winHeight>(docClientHeight-100))
		{
			winHeight=docClientHeight-100;
		}
		if ((winY>(docClientHeight-winY))&&(winY>winHeight)) {
			winY=winY-winHeight;
		} else if (((docClientHeight-winY)>winY)&&((docClientHeight-winY)>winHeight)) {
			winY=winY;
		} else {
			winY=(docClientHeight-winHeight)/2;
		}
		
		var docClientWidth=document.body.clientWidth;
		if (winX>(docClientWidth-winX)) {
			if (winWidth>(winX-200)){
				winWidth=winX-200;
			}
			winX=winX-winWidth;
		} else {
			if (winWidth>(docClientWidth-winX-200)){
				winWidth=docClientWidth-winX-200;
			}
		}
		
		var objWin = new Object();
		
		//客观变异项目=时间调整+路径外医嘱+必选项目未执行+可选项目已执行
		objWin.VarItemGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
		objWin.VarItemGridStore = new Ext.data.GroupingStore({
			proxy: objWin.VarItemGridStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'VarItemInd'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'VarItemInd', mapping: 'VarItemInd'}
				,{name: 'VarItemCode', mapping: 'VarItemCode'}
				,{name: 'VarItemDesc', mapping: 'VarItemDesc'}
				,{name: 'VarItemGroup', mapping: 'VarItemGroup'}
			])
			,sortInfo:{field:'VarItemInd',direction:'ASC'}
			,groupField:'VarItemGroup'
		});
		var sm = new Ext.grid.CheckboxSelectionModel({chekcOnly:true});
		objWin.VarItemGrid = new Ext.grid.GridPanel({
			id : 'VarItemGrid'
			,store : objWin.VarItemGridStore
			,region : 'center'
			,frame : true
			,buttonAlign : 'center'
			,viewConfig : {forceFit:true}
			,sm : sm
			,columns: [
				sm
				,{header: '变异项目', width: 80, dataIndex: 'VarItemDesc', sortable: false}
				,{header: '分组', width: 1, dataIndex: 'VarItemGroup', sortable: false,hidden:true}
			]
			,view : new Ext.grid.GroupingView({
				forceFit:true,
				groupTextTpl:'{[values.rs[0].get("VarItemGroup")]}(共{[values.rs.length]}条项目)',
				groupByText:'分组'
			})
		});
		objWin.VarItemGridStoreProxy.on('beforeload', function(objProxy, param){
			//param.ClassName = 'web.DHCCPW.MRC.FormExam';
			//update by zf 20150630 新版本变异记录查询
			param.ClassName = 'DHCCPW.MR.FORM.VarianceSrv';
			param.QueryName = 'QryVarItemList';
			param.Arg1 = PathWayID;
			param.Arg2 = objInp.id;
			param.Arg3 = CareProvTp
			param.ArgCnt = 3;
		});
		
		objWin.cboVarCategStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
		objWin.cboVarCategStore = new Ext.data.Store({
			proxy: objWin.cboVarCategStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'Rowid'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'Rowid', mapping: 'Rowid'}
				,{name: 'Code', mapping: 'Code'}
				,{name: 'Desc', mapping: 'Desc'}
			])
		});
		objWin.cboVarCateg = new Ext.form.ComboBox({
			width : 100
			,displayField : 'Desc'
			,minChars : 1
			,fieldLabel : '原因分类'
			,store : objWin.cboVarCategStore
			,editable : true
			,triggerAction : 'all'
			,anchor : '100%'
			,valueField : 'Rowid'
		});
		objWin.cboVarCategStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCCPW.MRC.VarianceCategory';
				param.QueryName = 'QryVarCateg';
				param.Arg1 = "V";
				param.ArgCnt = 1;
		});
		objWin.cboVarCategStore.load({});
		objWin.cboVarReasonStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
			}));
		objWin.cboVarReasonStore = new Ext.data.Store({
			proxy: objWin.cboVarReasonStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'Rowid'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'Rowid', mapping: 'Rowid'}
				,{name: 'Code', mapping: 'Code'}
				,{name: 'Desc', mapping: 'Desc'}
			])
		});
		objWin.cboVarReason = new Ext.form.ComboBox({
			width : 100
			,displayField : 'Desc'
			,minChars : 1
			,fieldLabel : '变异原因'
			,store : objWin.cboVarReasonStore
			,editable : true
			,triggerAction : 'all'
			,anchor : '100%'
			,valueField : 'Rowid'
		});
		objWin.cboVarReasonStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCCPW.MRC.VarianceReason';
				param.QueryName = 'QryVarReasonNew';
				param.Arg1 = objWin.cboVarCateg.getValue();
				param.Arg2 = 'Y';
				param.ArgCnt = 2;
		});
		//objWin.cboVarReasonStore.load({});
		objWin.txtaVarResume = new Ext.form.TextArea({
			height : 40
			,width : 100
			,fieldLabel : '原因备注'
			,anchor : '100%'
		});
		objWin.panelVar = new Ext.Panel({
			layout : 'form'
			,region : 'south'
			,width : '300px'
			,height : 80
			,frame : true
			,items : [
				{
					layout : 'column',
					items : [
						{
							columnWidth:.50,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 70,
							items : [objWin.cboVarCateg]
						},{
							columnWidth:.50,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 70,
							items : [objWin.cboVarReason]
						}
					]
				},{
					layout : 'column',
					items : [
						{
							columnWidth:1,
							layout : 'form',
							labelAlign : 'right',
							labelWidth : 70,
							items : [objWin.txtaVarResume]
						}
					]
				}
			]
		});
		
		objWin.cboVarCategStore.load({});
		objWin.cboVarCateg_OnSelect = function(){
			objWin.cboVarReason.clearValue();
			objWin.cboVarReasonStore.load({});
		}
		objWin.cboVarCateg.on("select", objWin.cboVarCateg_OnSelect, objWin);
		objWin.cboVarReason.on("expand", objWin.cboVarReason_OnExpand, objWin);
		
		win = new Ext.Window({
				////id : 'win',   //by wuqk 2012-02-22
				width : winWidth,
				height : winHeight,
				x : winX,
				y : winY,
				resizable : false,
				closable : true,
				autoScroll:false,
				animCollapse : false,
				//html:template,
				renderTo : document.body,
				layout : 'border',
				modal : true,
				title : winTitleSub,
				items : [
					objWin.VarItemGrid
					,objWin.panelVar
				],
				buttons : [{
					id : 'btnSave',
					text : '添加',
					iconCls : 'icon-add',
					listeners : {
						"click" : function(){
							var ErrInfo="";
							
							var varReason=objWin.cboVarReason.getValue();
							if (!varReason){
								ErrInfo = ErrInfo + "请选择变异原因,变异原因不允许为空!";
							}
							
							var varReasonResume=objWin.txtaVarResume.getValue();
							
							//update by zf 2012-04-18
							var varReasonDesc=objWin.cboVarReason.getRawValue();
							if (varReasonDesc.indexOf('其他') >= 0)
							{
								if (varReasonResume=='') {
									ErrInfo = ErrInfo + "请填写原因备注,备注不允许为空!";
								}
							}
							if (ErrInfo) {
								alert(ErrInfo);
								return;
							}
							
							var itemList="";
							var arrList = sm.getSelections();
							for (var rowIndex=0;rowIndex<arrList.length;rowIndex++){
								var r = arrList[rowIndex];
								itemList=itemList+r.get("VarItemCode")+","
							}
							
							var EpStepID=objInp.id;
							var InputStr=EpisodeID;
							InputStr=InputStr + "^" + varReason;
							InputStr=InputStr + "^" + varReasonResume;
							InputStr=InputStr + "^" + session['LOGON.USERID'];
							InputStr=InputStr + "^" + "";
							InputStr=InputStr + "^" + itemList;
							InputStr=InputStr + "^" + EpStepID;
							var objClinPathWaysVariance = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysVariance");
							var ret = objClinPathWaysVariance.UpdateExtraVar(InputStr);
							if (ret<0){
								ExtTool.alert("提示","变异原因填写错误!",Ext.MessageBox.ERROR);
								return;
							}else{
								objWin.VarItemGridStore.load({
									callback: function(records, options, success){
										var count=objWin.VarItemGridStore.getCount();
							       if (+count<1){
							       	  win.close();	
							       }
										objWin.VarItemGrid.getView().expandAllGroups();
									},
									scope: obj.VarItemGridStore,
									add: false
								});
								objWin.cboVarCateg.setValue('');
								objWin.cboVarReason.setValue('');
								objWin.txtaVarResume.setValue('');
								obj.formShowData(FORM_PageMode,0);
							}
						}
					}
				},{
					id : 'btnCancel',
					text : '取消',
					iconCls : 'icon-undo',
					listeners : {
						"click" : function(){
							objInp.value="";
							objInp.checked=false;
							winFlag=1;
							win.close();
						}
					}
				}],
				listeners :{
					"beforeclose" : function(){
						if (winFlag=="0"){
							objInp.value="";
							objInp.checked=false;
						}
					},
					"beforeshow" : function(){
						objWin.VarItemGridStore.load({
							callback: function(records, options, success){
								objWin.VarItemGrid.getView().expandAllGroups();
							},
							scope: obj.VarItemGridStore,
							add: false
						});
					}
				}
		});
		win.show();
	}
	
	function updateSign(EpStepID,CareProvTp){
		if (!EpStepID)  return false;
		var SignUserID=session['LOGON.USERID'];
		var objCTCareProvSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.CTCareProvSrv");
		var strCareProv=objCTCareProvSrv.GetCareProvByUserID(SignUserID);
		
		if (CareProvTp=="D") {
			var SignDoctorID=strCareProv.split("^")[0];
			var SignNurseID="";
		}else{
			var SignDoctorID="";
			var SignNurseID=strCareProv.split("^")[0];
		}
		
		var InputStr=PathWayID;
		InputStr=InputStr + "^" + EpStepID;
		InputStr=InputStr + "^" + SignDoctorID;
		InputStr=InputStr + "^" + SignNurseID;
		InputStr=InputStr + "^" + "Y";
		InputStr=InputStr + "^" + "";
		InputStr=InputStr + "^" + "";
		InputStr=InputStr + "^" + SignUserID;
		
		var objSignSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysSign");
		var ret=objSignSrv.Update(InputStr);
		if (ret<0){
			ExtTool.alert("提示","更新失败!");
			return false;
		} else {
			/*
			////loaddata-wuqk  --签名后刷新--
			var xdata=GetFormData(PathWayID,CPWID);
			tpl2.compile();
			tpl2.overwrite(formPanel.body,xdata);
			formPanel.doLayout();
			Container.doLayout();
			loadEvent();*/
			
			obj.formShowData(FORM_PageMode,0);
			return true;
		}
	}
	
	function updoSign(IDList){
		var objSignSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysSign");
		for (var i=0;i<IDList.length;i++){
			var SignID=IDList[i];
			var InputStr = SignID + "^" + session['LOGON.USERID'];
			var flg=objSignSrv.UpdoSign(InputStr);
		}
		/*
			////loaddata-wuqk  --撤销签名后刷新--
		var xdata=GetFormData(PathWayID,CPWID);
		tpl2.compile();
		tpl2.overwrite(formPanel.body,xdata);
		formPanel.doLayout();
		Container.doLayout();
		loadEvent();*/
		obj.formShowData(FORM_PageMode,0);
		return true;
	}
	
	//医生签名+护士签名
	function onDoctorSignClick(objInp,evt,winTitleSub,CareProvTp){
		if (!objInp.checked) return;
		objInp.value="";
		objInp.checked=false;
		var objFormExamSrv = ExtTool.StaticServerObject("DHCCPW.MR.FORM.VarianceSrv");
		var ret = objFormExamSrv.ChkVarItemList(PathWayID,objInp.id,CareProvTp);
		if (parseInt(ret)>0) {
			ExtTool.alert("提示","此步骤存在变异,请填写病情变异记录后再签名!");
			return;
		}
		if (CareProvTp=="D") {
			ExtTool.confirm("医师签名确认","请确认是否进行医师签名?",function(btn){
				if (btn=='yes'){
					updateSign(objInp.id,CareProvTp);
				}
			})
		}else{
			ExtTool.confirm("护士签名确认","请确认是否进行护士签名?",function(btn){
				if (btn=='yes'){
					updateSign(objInp.id,CareProvTp);
				}
			})
		}
	}
	
	//统一签名+集中处理变异记录 add by mxp 2016-12-07
	function onSignAllClick(winTitleSub,CareProvTp){
		var objWin = new Object();
		objWin.checkEpStepDR="";

		//全选/反选		
		var UnSelectAll = function(grid){
			var hd_checker = grid.getEl().select('div.x-grid3-hd-checker');
			var hd = hd_checker.first();
			if(hd != null){
				var selectedCount = grid.getSelectionModel().getSelections().length;
				var storeCount = grid.getStore().getCount();
				if((selectedCount != storeCount)||(storeCount==0)){
					if (hd.hasClass('x-grid3-hd-checker-on')) {
						hd.removeClass('x-grid3-hd-checker-on');
					}
				}else{
					if (!hd.hasClass('x-grid3-hd-checker-on')) {
						hd.addClass('x-grid3-hd-checker-on');
					}
				}
			}
		}
		
		//变异处理
		objWin.VarItemGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
		objWin.VarItemGridStore = new Ext.data.GroupingStore({
			proxy: objWin.VarItemGridStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'VarItemInd'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'VarItemInd', mapping: 'VarItemInd'}
				,{name: 'VarItemCode', mapping: 'VarItemCode'}
				,{name: 'VarItemDesc', mapping: 'VarItemDesc'}
				,{name: 'VarItemGroup', mapping: 'VarItemGroup'}
			])
			,sortInfo:{field:'VarItemInd',direction:'ASC'}
			,groupField:'VarItemGroup'
			,listeners:{
				'datachanged':function(){
					UnSelectAll(objWin.VarItemGrid);
				}
			}
		});
		
		var smVar = new Ext.grid.CheckboxSelectionModel({chekcOnly:true,check:true});
		objWin.VarItemGrid = new Ext.grid.GridPanel({
			id : 'VarItemGrid'
			,store : objWin.VarItemGridStore
			,region : 'center'
			,frame : true
			,height : 220
			,width : 350
			,buttonAlign : 'center'
			,viewConfig : {forceFit:true}
			,sm : smVar
			,columns: [
				smVar
				,{header: '变异项目', width: 80, dataIndex: 'VarItemDesc', sortable: false
					,renderer: function(v, m, rd, r, c, s)
					{
						m.attr = 'style="white-space:normal;"';
						return v;
					}				
				}
				,{header: '分组', width: 1, dataIndex: 'VarItemGroup', sortable: false,hidden:true}
			]
			,view : new Ext.grid.GroupingView({
				forceFit:true,
				groupTextTpl:'{[values.rs[0].get("VarItemGroup")]}(共{[values.rs.length]}条项目)',
				groupByText:'分组'
			})
			,listeners :{
				"rowclick" : function(grid,rowIndex,event){
					UnSelectAll(objWin.VarItemGrid);
				}
			}
		});
		objWin.VarItemGridStoreProxy.on('beforeload', function(objProxy, param){
			//param.ClassName = 'web.DHCCPW.MRC.FormExam';
			param.ClassName = 'DHCCPW.MR.FORM.VarianceSrv';
			param.QueryName = 'QryVarItemList';
			param.Arg1 = PathWayID;
			param.Arg2 = objWin.checkEpStepDR;
			param.Arg3 = CareProvTp;
			param.ArgCnt = 3;
		});				
			
		objWin.cboVarCategStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
		objWin.cboVarCategStore = new Ext.data.Store({
			proxy: objWin.cboVarCategStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'Rowid'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'Rowid', mapping: 'Rowid'}
				,{name: 'Code', mapping: 'Code'}
				,{name: 'Desc', mapping: 'Desc'}
			])
		});
		objWin.cboVarCateg = new Ext.form.ComboBox({
			displayField : 'Desc'
			,minChars : 1
			,fieldLabel : '原因分类'
			,store : objWin.cboVarCategStore
			,editable : true
			,triggerAction : 'all'
			,anchor : '100%'
			,valueField : 'Rowid'
		});
		objWin.cboVarCategStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCCPW.MRC.VarianceCategory';
				param.QueryName = 'QryVarCateg';
				param.Arg1 = "V";
				param.ArgCnt = 1;
		});
		objWin.cboVarCategStore.load({});
		objWin.cboVarReasonStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
			}));
		objWin.cboVarReasonStore = new Ext.data.Store({
			proxy: objWin.cboVarReasonStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'Rowid'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'Rowid', mapping: 'Rowid'}
				,{name: 'Code', mapping: 'Code'}
				,{name: 'Desc', mapping: 'Desc'}
			])
		});
		objWin.cboVarReason = new Ext.form.ComboBox({
			displayField : 'Desc'
			,minChars : 1
			,fieldLabel : '变异原因'
			,store : objWin.cboVarReasonStore
			,editable : true
			,triggerAction : 'all'
			,anchor : '100%'
			,valueField : 'Rowid'
		});
		objWin.cboVarReasonStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCCPW.MRC.VarianceReason';
				param.QueryName = 'QryVarReasonNew';
				param.Arg1 = objWin.cboVarCateg.getValue();
				param.Arg2 = 'Y';
				param.ArgCnt = 2;
		});
		//objWin.cboVarReasonStore.load({});
		objWin.txtaVarResume = new Ext.form.TextArea({
			height : 40
			//,width : 100
			,fieldLabel : '原因备注'
			,anchor : '100%'
		});
		objWin.panelVar = new Ext.Panel({
			layout : 'form'
			,region : 'west'
			,width : 350
			,title : '变异记录信息'
			,labelAlign : 'right'
			,labelWidth : 70
			//,height : 160
			,frame : true
			,items : [
				objWin.VarItemGrid,
				objWin.cboVarCateg
				,objWin.cboVarReason
				,objWin.txtaVarResume				
			]
			,buttons : [
				{
					text: '添加变异记录'
					,id : 'btnSave'
					,iconCls: 'icon-add'
					,handler: function(){
						var ErrInfo="";
						
						var itemList="";
						var arrList = smVar.getSelections();
						if (arrList.length<1) ErrInfo = ErrInfo + "请选择变异项目!\r\n";
						
						for (var rowIndex=0;rowIndex<arrList.length;rowIndex++){
							var r = arrList[rowIndex];
							itemList=itemList+r.get("VarItemCode")+","
						}
						
						var varReason=objWin.cboVarReason.getValue();
						if (!varReason){
							ErrInfo = ErrInfo + "请选择变异原因,变异原因不允许为空!\n\r";
						}
						
						var varReasonResume=objWin.txtaVarResume.getValue();							
						var varReasonDesc=objWin.cboVarReason.getRawValue();
						if (varReasonDesc.indexOf('其他') >= 0)
						{
							if (varReasonResume=='') {
								ErrInfo = ErrInfo + "请填写原因备注,备注不允许为空!";
							}
						}
						if (ErrInfo) {
							alert(ErrInfo);
							return;
						}

						var InputStr=EpisodeID;
						InputStr=InputStr + "^" + varReason;
						InputStr=InputStr + "^" + varReasonResume;
						InputStr=InputStr + "^" + session['LOGON.USERID'];
						InputStr=InputStr + "^" + "";
						InputStr=InputStr + "^" + itemList;
						InputStr=InputStr + "^" + objWin.checkEpStepDR;
	
						var objClinPathWaysVariance = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysVariance");
						var ret = objClinPathWaysVariance.UpdateExtraVar(InputStr);
						if (ret<0){
							ExtTool.alert("提示","变异原因填写错误!",Ext.MessageBox.ERROR);
							return;
						}else{
							smVar.clearSelections();
							objWin.VarItemGridStore.reload();								
							objWin.cboVarCateg.setValue('');
							objWin.cboVarReason.setValue('');
							objWin.txtaVarResume.setValue('');
							objWin.AllSignInfoStore.load({});
						}
					}
				}
			]
		});
					
		objWin.cboVarCateg_OnSelect = function(){
			objWin.cboVarReason.clearValue();
			objWin.cboVarReasonStore.load({});
		}
		objWin.cboVarCateg.on("select", objWin.cboVarCateg_OnSelect, objWin);
		
		objWin.AllSignInfoStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
		objWin.AllSignInfoStore = new Ext.data.GroupingStore({
			proxy: objWin.AllSignInfoStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'VarItemInd'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'EpStepID', mapping: 'EpStepID'}
				,{name: 'EpStepDesc', mapping: 'EpStepDesc'}
				,{name: 'IsVariance', mapping: 'IsVariance'}
				,{name: 'DoctorSign', mapping: 'DoctorSign'}
				,{name: 'NurseSign', mapping: 'NurseSign'}
			])
		});
		var smSign = new Ext.grid.CheckboxSelectionModel({chekcOnly:true,check:true
			,renderer: function(val,col,record) {
  				if (((record.get("DoctorSign")!="")&&(CareProvTp=="D"))||((record.get("NurseSign")!="")&&(CareProvTp=="N"))) {
  					return ''; // 有选择框
  				}
  				else {
  					return '<div class="x-grid3-row-checker"></div>' //'<input type="checkbox" />'; // 没有选择框
  				}
  			} 		
		});
		objWin.AllSignInfo = new Ext.grid.GridPanel({
			id : 'AllSignInfo'
			,store : objWin.AllSignInfoStore
			,region : 'center'
			,title : '签名及变异情况'
			,frame : true
			,buttonAlign : 'center'
			//,viewConfig : {forceFit:true}
			,sm : smSign
			,columns: [
				smSign
				,{header: '阶段步骤', width: 150, dataIndex: 'EpStepDesc', sortable: false,align:'center'}
				,{header: '是否存在<br>变异', width: 70, dataIndex: 'IsVariance', sortable: false,align:'center'}
				,{header: '医师签名', width: 100, dataIndex: 'DoctorSign', sortable: false,align:'center'}
				,{header: '护士签名', width: 100, dataIndex: 'NurseSign', sortable: false,align:'center'}
			]
			,listeners :{
				"rowclick" : function(grid,rowIndex,event){
					UnSelectAll(objWin.AllSignInfo);
					var record = grid.getStore().getAt(rowIndex);
					var EpStepID = record.get("EpStepID");
					objWin.checkEpStepDR="";
					var arrList = smSign.getSelections();
					for (var rowIndex=0;rowIndex<arrList.length;rowIndex++){
						var rec = arrList[rowIndex];
						if (rec.get("EpStepID")==EpStepID) {
							objWin.checkEpStepDR=EpStepID;
							//objWin.panelVartitle = "步骤["+rec.get("EpStepDesc")+"]变异信息";
						}
					}
					//objWin.panelVar.doLayout();
					objWin.VarItemGridStore.load({});
				}
			}
		});
		objWin.AllSignInfoStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.ClinPathWaysSign';
			param.QueryName = 'QrySignInfo';
			param.Arg1 = PathWayID;
			param.Arg2 = CareProvTp;
			param.ArgCnt = 2;
		});		
		objWin.AllSignInfoStore.load({});
		
	var win1 = new Ext.Window({
				width : 800,
				height : 450,
				resizable : false,
				closable : true,
				autoScroll:false,
				animCollapse : false,
				renderTo : document.body,
				layout : 'border',
				modal : true,
				title : winTitleSub,
				items : [
					objWin.panelVar,objWin.AllSignInfo
				]
				,buttons : [{
					id : 'btnConfirm',
					iconCls: 'icon-update',
					text : '签名',
					listeners : {
						"click" : function(){
							var IsVarStr="";
							var arrList = smSign.getSelections();
							if (arrList.length<1) {
								alert("请选择要签名的步骤!");
								return;
							}
							for (var rowIndex=0;rowIndex<arrList.length;rowIndex++){
								var record = arrList[rowIndex];
								if (record.get("IsVariance")=="是") {
									IsVarStr += "、" + record.get("EpStepDesc");
									continue;
								}
								var EpStepID=record.get("EpStepID");
								updateSign(EpStepID,CareProvTp);
							}
							IsVarStr=IsVarStr.substring(1,IsVarStr.length);
							if (IsVarStr!="")	{
								alert("步骤["+IsVarStr+"]存在变异,请填写病情变异记录后再签名!");
								return;
							}
							objWin.AllSignInfoStore.load({});							
						}
					}
				},{
					id : 'btnCancel',
					text : '关闭',
					iconCls : 'icon-cancel',
					listeners : {
						"click" : function(){
							win1.close();
							obj.formShowData(FORM_PageMode,0);
						}
					}
				}]
		});
		win1.show();
	}
	
	//弹出调整实施路径步骤时间事件
	function onEstClick(objInp,evt,winTitleSub){
		var tmpStr=objInp.id;
		var tmpList=tmpStr.split("/");
		if (tmpList.length<4) return;
		var stepId=tmpList[0];
		var tmpSubList=tmpList[1].split("～");
		var isStart=tmpList[2];
		var estTime=tmpList[3];
		var startTime=tmpSubList[0];
		var endTime=tmpSubList[1];
		var userid=session['LOGON.USERID'];
		if ((!startTime)||(!endTime)||(!stepId)) return;
		
		var winFlag=0;
		var winHeight=165;
		var winWidth=200;
		var winX=evt.clientX;
		var winY=evt.clientY;
		
		var docClientHeight=document.body.clientHeight;
		if (winHeight>(docClientHeight-100))
		{
			winHeight=docClientHeight-100;
		}
		if ((winY>(docClientHeight-winY))&&(winY>winHeight)) {
			winY=winY-winHeight;
		} else if (((docClientHeight-winY)>winY)&&((docClientHeight-winY)>winHeight)) {
			winY=winY;
		} else {
			winY=(docClientHeight-winHeight)/2;
		}
		
		var docClientWidth=document.body.clientWidth;
		if (winX>(docClientWidth-winX)) {
			if (winWidth>(winX-200)){
				winWidth=winX-200;
			}
			winX=winX-winWidth;
		} else {
			if (winWidth>(docClientWidth-winX-200)){
				winWidth=docClientWidth-winX-200;
			}
		}
				
		var objWin = new Object();
		objWin.dfDateFromX = new Ext.form.DateField({
			id : 'dfDateFromX'
			,format : 'Y-m-d H:i:s'
			,width : 80
			,fieldLabel : '开始日期'
			,anchor : '95%'
			,altFormats : 'Y-m-d H:i:s|d/m/Y H:i:s'
			,value : startTime
			,disabled : (isStart==0)
		});
		objWin.dfDateToX = new Ext.form.DateField({
			id : 'dfDateToX'
			,format : 'Y-m-d H:i:s'
			,width : 80
			,fieldLabel : '结束日期'
			,anchor : '95%'
			,altFormats : 'Y-m-d H:i:s|d/m/Y H:i:s'
			,value : endTime
			,disabled : false
		});
		objWin.txtStepTime = new Ext.form.TextField({
			id : 'txtStepTime'
			,width : 80
			,fieldLabel : '实际时间'
			,anchor : '95%'
			,disabled : true
			,value : estTime
		});
		objWin.ConditionPanel = new Ext.Panel({
			id : 'ConditionPanel'
			,buttonAlign : 'center'
			,labelAlign : 'right'
			,labelWidth : 70
			,bodyBorder : 'padding:0 0 0 0'
			,layout : 'form'
			,frame : true
			,items:[
				objWin.dfDateFromX
				,objWin.dfDateToX
				//,objWin.txtStepTime
			]
		});
		
		win = new Ext.Window({
				//id : 'win',   //by wuqk 2012-02-22
				width : 300,
				height : winHeight,
				x : winX,
				y : winY,
				resizable : false,
				closable : true,
				autoScroll:true,
				animCollapse : true,
				//html:template,
				renderTo : document.body,
				layout : 'fit',
				modal : true,
				title : winTitleSub,
				items : [
					objWin.ConditionPanel
				],
				buttons : [{
					id : 'btnConfirm',
					text : '确定',
					iconCls : 'icon-confirm',
					listeners : {
						"click" : function(){
							startTime=objWin.dfDateFromX.getRawValue();
							endTime=objWin.dfDateToX.getRawValue();
							var inputStr=PathWayID+"^"+stepId+"^"+startTime+"^"+endTime+"^"+userid;
							updateEstimate(inputStr);
							objInp.value="";
							objInp.checked=false;
							win.close();
						}
					}
				},{
					id : 'btnCancel',
					text : '取消',
					iconCls : 'icon-undo',
					listeners : {
						"click" : function(){
							objInp.value="";
							objInp.checked=false;
							win.close();
						}
					}
				}],
				listeners :{
					"beforeclose" : function(){
						objInp.checked=false;
					}
				}
		});
		win.show();
	}
	
	//撤销病情变异记录事件
	function onUpdoVarClick(objInp,evt,winTitleSub){
		if (!objInp.checked) return;
		
		var winFlag=0;
		
		var winHeight=225;
		var winWidth=400;
		var winX=evt.clientX;
		var winY=evt.clientY;
		
		var docClientHeight=document.body.clientHeight;
		if (winHeight>(docClientHeight-100))
		{
			winHeight=docClientHeight-100;
		}
		if ((winY>(docClientHeight-winY))&&(winY>winHeight)) {
			winY=winY-winHeight;
		} else if (((docClientHeight-winY)>winY)&&((docClientHeight-winY)>winHeight)) {
			winY=winY;
		} else {
			winY=(docClientHeight-winHeight)/2;
		}
		
		var docClientWidth=document.body.clientWidth;
		if (winX>(docClientWidth-winX)) {
			if (winWidth>(winX-200)){
				winWidth=winX-200;
			}
			winX=winX-winWidth;
		} else {
			if (winWidth>(docClientWidth-winX-200)){
				winWidth=docClientWidth-winX-200;
			}
		}
		
		var objWin = new Object();
		objWin.VarRstStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
		objWin.VarRstStore = new Ext.data.Store({
			proxy: objWin.VarRstStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'VID'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'VID', mapping: 'VID'}
				,{name: 'VEpisodeDR', mapping: 'VEpisodeDR'}
				,{name: 'VEpisodeDesc', mapping: 'VEpisodeDesc'}
				,{name: 'VCategoryDR', mapping: 'VCategoryDR'}
				,{name: 'VCategoryDesc', mapping: 'VCategoryDesc'}
				,{name: 'VReasonDR', mapping: 'VReasonDR'}
				,{name: 'VReasonDesc', mapping: 'VReasonDesc'}
				,{name: 'VUserDR', mapping: 'VUserDR'}
				,{name: 'VUserDesc', mapping: 'VUserDesc'}
				,{name: 'VDate', mapping: 'VDate'}
				,{name: 'VTime', mapping: 'VTime'}
				,{name: 'VNote', mapping: 'VNote'}
				,{name: 'VDoctorDR', mapping: 'VDoctorDR'}
				,{name: 'VDoctorDesc', mapping: 'VDoctorDesc'}
			])
		});
		objWin.VarRstCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
		objWin.VarRst = new Ext.grid.GridPanel({
			id : 'VarRst'
			,store : objWin.VarRstStore
			,region : 'center'
			,frame : true
			,buttonAlign : 'center'
			,viewConfig : {forceFit:true}
			,columns: [
				objWin.VarRstCheckCol
				,{header: '原因', width: 200, dataIndex: 'VReasonDesc', sortable: false}
				,{header: '备注', width: 200, dataIndex: 'VNote', sortable: false}
				,{header: '医生', width: 60, dataIndex: 'VDoctorDesc', sortable: true}
			]
			,plugins:objWin.VarRstCheckCol
		});
		objWin.VarRstStoreProxy.on('beforeload', function(objProxy, param){
					param.ClassName = 'web.DHCCPW.MR.ClinPathWaysVariance';
					param.QueryName = 'QryVarByStep';
					param.Arg1 = PathWayID;
					param.Arg2 = objInp.id;
					param.ArgCnt = 2;
		});
		objWin.VarRstStore.load({});
		win = new Ext.Window({
				//id : 'win',   //by wuqk 2012-02-22
				width : 400,
				height : winHeight,
				x : winX,
				y : winY,
				resizable : false,
				closable : true,
				autoScroll:true,
				animCollapse : true,
				//html:template,
				renderTo : document.body,
				layout : 'fit',
				modal : true,
				title : winTitleSub,
				items : [
					objWin.VarRst
				],
				buttons : [{
					id : 'btnConfirm',
					text : '确定',
					iconCls : 'icon-confirm',
					listeners : {
						"click" : function(){
							var IDList = new Array();
							for (var i=0;i<objWin.VarRstStore.getCount();i++){
								var objRec=objWin.VarRstStore.getAt(i);
								if (objRec.get("checked")==false) continue;
								var VarID=objRec.get("VID");
								IDList.push(VarID);
							}
							var flg=updoVariance(IDList);
							if (flg){
								objInp.value="";
								objInp.checked=false;
								winFlag=1;
								win.close();
							}
						}
					}
				},{
					id : 'btnCancel',
					text : '取消',
					iconCls : 'icon-undo',
					listeners : {
						"click" : function(){
							objInp.value="";
							objInp.checked=false;
							winFlag=1;
							win.close();
						}
					}
				}],
				listeners :{
					"beforeclose" : function(){
						if (winFlag=="0"){
							objInp.value="";
							objInp.checked=false;
						}
					},
					"beforeshow" : function(){
						//objWin.VarRst.on("click", objWin.VarRst_OnClick, objWin);
					}
				}
		});
		win.show();
	}
	
	//撤销医师签名或护士签名记录事件
	function onUpdoSignClick(objInp,evt,winTitleSub,CareProvTp){
		if (!objInp.checked) return;
		
		var winFlag=0;
		
		var winHeight=225;
		var winWidth=400;
		var winX=evt.clientX;
		var winY=evt.clientY;
		
		var docClientHeight=document.body.clientHeight;
		if (winHeight>(docClientHeight-100))
		{
			winHeight=docClientHeight-100;
		}
		if ((winY>(docClientHeight-winY))&&(winY>winHeight)) {
			winY=winY-winHeight;
		} else if (((docClientHeight-winY)>winY)&&((docClientHeight-winY)>winHeight)) {
			winY=winY;
		} else {
			winY=(docClientHeight-winHeight)/2;
		}
		
		var docClientWidth=document.body.clientWidth;
		if (winX>(docClientWidth-winX)) {
			if (winWidth>(winX-200)){
				winWidth=winX-200;
			}
			winX=winX-winWidth;
		} else {
			if (winWidth>(docClientWidth-winX-200)){
				winWidth=docClientWidth-winX-200;
			}
		}
		
		var objWin = new Object();
		objWin.SignRstStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
		objWin.SignRstStore = new Ext.data.Store({
			proxy: objWin.SignRstStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'SignID'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'SignID', mapping: 'SignID'}
				,{name: 'SignCareProvDR', mapping: 'SignCareProvDR'}
				,{name: 'SignCareProvName', mapping: 'SignCareProvName'}
				,{name: 'SignDate', mapping: 'SignDate'}
				,{name: 'SignTime', mapping: 'SignTime'}
				,{name: 'SignUserDR', mapping: 'SignUserDR'}
				,{name: 'SignUserDesc', mapping: 'SignUserDesc'}
			])
		});
		objWin.SignRstCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
		objWin.SignRst = new Ext.grid.GridPanel({
			id : 'SignRst'
			,store : objWin.SignRstStore
			,region : 'center'
			,frame : true
			,buttonAlign : 'center'
			,viewConfig : {forceFit:true}
			,columns: [
				objWin.SignRstCheckCol
				,{header: '签名', width: 100, dataIndex: 'SignCareProvName', sortable: false}
				,{header: '日期', width: 80, dataIndex: 'SignDate', sortable: false}
				,{header: '时间', width: 60, dataIndex: 'SignTime', sortable: true}
			]
			,plugins:objWin.SignRstCheckCol
		});
		objWin.SignRstStoreProxy.on('beforeload', function(objProxy, param){
					param.ClassName = 'web.DHCCPW.MR.ClinPathWaysSign';
					param.QueryName = 'QrySignByStep';
					param.Arg1 = PathWayID;
					param.Arg2 = objInp.id;
					param.Arg3 = CareProvTp;
					param.ArgCnt = 3;
		});
		objWin.SignRstStore.load({});
		win = new Ext.Window({
				//id : 'win',   //by wuqk 2012-02-22
				width : 400,
				height : winHeight,
				x : winX,
				y : winY,
				resizable : false,
				closable : true,
				autoScroll:true,
				animCollapse : true,
				//html:template,
				renderTo : document.body,
				layout : 'fit',
				modal : true,
				title : winTitleSub,
				items : [
					objWin.SignRst
				],
				buttons : [{
					id : 'btnConfirm',
					text : '确定',
					iconCls : 'icon-confirm',
					listeners : {
						"click" : function(){
							var IDList = new Array();
							for (var i=0;i<objWin.SignRstStore.getCount();i++){
								var objRec=objWin.SignRstStore.getAt(i);
								if (objRec.get("checked")==false) continue;
								var SignID=objRec.get("SignID");
								IDList.push(SignID);
							}
							var flg=updoSign(IDList);
							if (flg){
								objInp.value="";
								objInp.checked=false;
								winFlag=1;
								win.close();
							}
						}
					}
				},{
					id : 'btnCancel',
					text : '取消',
					iconCls : 'icon-undo',
					listeners : {
						"click" : function(){
							objInp.value="";
							objInp.checked=false;
							winFlag=1;
							win.close();
						}
					}
				}],
				listeners :{
					"beforeclose" : function(){
						if (winFlag=="0"){
							objInp.value="";
							objInp.checked=false;
						}
					},
					"beforeshow" : function(){
						//objWin.SignRst.on("click", objWin.SignRst_OnClick, objWin);
					}
				}
		});
		win.show();
	}
	
	//弹出门诊医嘱窗体再选择项目事件
	function onOutOrderClick(objInp,evt,winTitleSub){
		if (!objInp.checked) return;
		
		var winFlag=0;
		var childrenItems=objInp.parentElement.parentElement.getElementsByTagName("span");
		var childLen=childrenItems.length;
		var rows=0;
		var tempItems="";
		var template = '<table>';
		for (var ind=0;ind<childLen;ind++){
			node=childrenItems[ind];
			
			itemString = '<tr><td>';
			itemString+=separete;
			itemString+='</td>';
			itemString+='<td colspan="2" style="WIDTH: 350px">';
			itemString+=node.outerHTML;
			itemString+='</td></tr>';
			rows+=1;
			
			itemString+='<tr><td>'+separete+'</td><td><input type="radio" name="Radio_ITEM'+rows+'"';
			itemString+=' id="'+node.id;
			itemString+='^1" value="门诊已执行" >&nbsp;&nbsp;&nbsp;&nbsp;';
			itemString+='门诊已执行';
			itemString+='</td></tr>';
			itemString+='<tr><td>'+separete+'</td><td><input type="radio" name="Radio_ITEM'+rows+'"';
			itemString+=' id="'+node.id;
			itemString+='^2" value="" checked>&nbsp;&nbsp;&nbsp;&nbsp;';
			itemString+='其他(填写具体内容：)';
			itemString+='&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="Text_ITEM'+rows+'" id="TEXT_';
			itemString+=node.id;
			itemString+='" style="WIDTH: 160px" >';
			itemString+='</td></tr>';
			rows+=1;
			
			template+=itemString;
		}
		template+='</table>';
		
		var winHeight=rows*40+85;
		var winWidth=400;
		var winX=evt.clientX;
		var winY=evt.clientY;
		
		var docClientHeight=document.body.clientHeight;
		if (winHeight>(docClientHeight-100))
		{
			winHeight=docClientHeight-100;
		}
		if ((winY>(docClientHeight-winY))&&(winY>winHeight)) {
			winY=winY-winHeight;
		} else if (((docClientHeight-winY)>winY)&&((docClientHeight-winY)>winHeight)) {
			winY=winY;
		} else {
			winY=(docClientHeight-winHeight)/2;
		}
		
		var docClientWidth=document.body.clientWidth;
		if (winX>(docClientWidth-winX)) {
			if (winWidth>(winX-200)){
				winWidth=winX-200;
			}
			winX=winX-winWidth;
		} else {
			if (winWidth>(docClientWidth-winX-200)){
				winWidth=docClientWidth-winX-200;
			}
		}
		
		win = new Ext.Window({
				//id : 'win',   //by wuqk 2012-02-22
				width : 400,
				height : winHeight,
				x : winX,
				y : winY,     //removed by wuqk 2010-11-17
				resizable : false,
				closable : true,
				autoScroll:true,
				animCollapse : true,
				html:template,
				renderTo : document.body,
				layout : 'fit',
				modal : true,
				title : winTitleSub,
				buttons : [{
					id : 'btnConfirm',
					text : '确定',
					iconCls : 'icon-confirm',
					listeners : {
						"click" : function(){
							var OutOrderflag = 0;
							for (var indRadioCount=0;indRadioCount<childLen*2;indRadioCount++)	//修复5个以上临床路径项目标记执行不成功 by liyi
							{
								var radioItem=document.getElementsByName("Radio_ITEM"+indRadioCount);
								for (var indRadio=0;indRadio<radioItem.length;indRadio++)
								{
									if (radioItem(indRadio).checked){
										var itemId=radioItem(indRadio).id;
										itemId=itemId.substring(0,itemId.length-2);
										var procNote=radioItem(indRadio).value;
										var textObj=document.getElementById("TEXT_"+itemId);
										if (textObj){
											if (textObj.value!==''){
												procNote=procNote+","+textObj.value;
											}
										}
										if (procNote!=="") {
											onOutOrderEntryClick(itemId,"",procNote);
											OutOrderflag = 1;
										}else{
											ExtTool.alert("提示","请填写具体内容!");
										}
									}
								}
							}
							if (OutOrderflag==1){
								objInp.value="";
								objInp.checked=false;
								winFlag=1;
								win.close();
							}
						}
					}
				},{
					id : 'btnCancel',
					text : '取消',
					iconCls : 'icon-undo',
					listeners : {
						"click" : function(){
							objInp.value="";
							objInp.checked=false;
							winFlag=1;
							win.close();
						}
					}
				}],
				listeners :{
					"beforeclose" : function(){
						if (winFlag=="0"){
							objInp.value="";
							objInp.checked=false;
						}
					},
					"beforeshow" : function(){
						var chkItems=document.getElementsByName("CHECK_ITEM");
						for (i=0;i<chkItems.length;i++){
							var checkObj=chkItems[i];
							if (checkObj.type=="checkbox"){
								var textObj=document.getElementById("TEXT_"+checkObj.id);
								if (textObj) {
									checkObj.onclick=function(){
										textObj.disabled=(!checkObj.checked);
										if (!checkObj.checked) {
											textObj.value="";
										}
									}
								} else {
									checkObj.onclick=function(){
										var winTitleSub="关联门(急)诊医嘱";
										onOutOrderSubClick(this,event,winTitleSub);
										if (!checkObj.checked) {
											checkObj.value="";
										}
									}
								}
							}
						}
					}
				}
		});
		win.show();
	}
	
	//弹出选择门诊医嘱界面
	function onOutOrderSubClick(objInpSub,evt,winTitleSub){
		if (!objInpSub.checked) return;
		objInpSub.checked=false;
		objInpSub.value="";
	}
	
	//下门诊医嘱
	function onOutOrderEntryClick(ItemID,IdList,ProcNote){
		if (ItemID=="") return;
		if ((IdList=="")&&(ProcNote=="")) return;
		var service = ExtTool.StaticServerObject("web.DHCCPW.MR.Implement");
		var ret=service.doImplOutOrder(PathWayID,ItemID,IdList,ProcNote,session['LOGON.USERID']);
		//alert(ret);
		if (ret) {
			/*
			////loaddata-wuqk  --标记医嘱执行后刷新--
			var xdata=GetFormData(PathWayID,CPWID);
			tpl2.compile();
			tpl2.overwrite(formPanel.body,xdata);
			formPanel.doLayout();
			Container.doLayout();*/
			obj.formShowData(FORM_PageMode,0);
			//loadEvent();
		}
	}
	
	//弹出下医嘱(护嘱)窗体再选择项目事件
	function onOrderClick(objInp,evt,winTitleSub){
		if (!objInp.checked) return;
		
		//update by zf 20150617
		objInp.checked = false;
		var ItemID = objInp.id;
		var arrItemID = ItemID.split(",");
		var ItemIDs = '',StepID = '',SubCatID = '';
		for (var ind = 0; ind < arrItemID.length; ind++) {
			var tmpItemID = arrItemID[ind];
			if (tmpItemID == '') continue;
			var ItemID=tmpItemID.split("-")[0];
			var StepID=tmpItemID.split("-")[1];
			var SubCatID=tmpItemID.split("-")[2];
			if (ItemIDs == '') {
				ItemIDs = ItemID;
			} else {
				ItemIDs += ',' + ItemID;
			}
		}
		var win = new OE_InitOEOrder(EpisodeID,StepID,SubCatID,ItemIDs);
		win.OE_WinOEOrder.show();
		return;
		
		var winFlag=0;
		var childrenItems=objInp.parentElement.parentElement.getElementsByTagName("span");
		var childLen=childrenItems.length;
		var rows=0,arcimCount=0;
		var tempItems="";
		var template = '<table>';
		for (var ind=0;ind<childLen;ind++){
			node=childrenItems[ind];
			var arrayArcim=GetItemACRIM(node.id);
			itemString = '<tr><td>';
			if (arrayArcim.length>=1){                   //包含一条或多条医嘱项
				itemString+=separete;
			}else{                                       //不包含医嘱项
				tempItems=node.id;
			}
			itemString+='</td>'
			itemString+='<td colspan="2">'
			itemString+=node.outerHTML;
			itemString+='</td></tr>';
			rows+=1;
			if (arrayArcim.length>=1){
				for (var indexAcrim=0;indexAcrim<arrayArcim.length;indexAcrim++){
					rows+=1;
					arcimCount++;
					var objItemArcim=arrayArcim[indexAcrim];
					itemString+='<tr><td>'+separete+'</td><td>';
					itemString+='<input type="checkbox" name="CHECK_ITEM" ';
					if (objItemArcim.defaults=="Y") itemString+=' checked ';
					itemString+=' id="'+node.id+'^'+objItemArcim.Index+'^'+objItemArcim.itmLinkNo+'" >';
					//update by zf 20120316 斜体显示不清楚
					//itemString+='<td><span><i>'+objItemArcim.arcimDesc+'</i></span></td>';
					itemString+='<td><span>'+objItemArcim.arcimDesc+'</span></td>';
					itemString+='</tr>';
				}
			}
			template+=itemString;
		}
		template+='</table>';
		
		if (arcimCount<1) {      //项目不包含医嘱，修改checkbox的value、checked
			objInp.value=tempItems;
			objInp.checked=false;
			return;
		}
		var winHeight=rows*30+85;
		var winWidth=400;
		var winX=evt.clientX;
		var winY=evt.clientY;
		
		var docClientHeight=document.body.clientHeight;
		if (winHeight>(docClientHeight-100))
		{
			winHeight=docClientHeight-100;
		}
		winHeight = winHeight + 20;
		if ((winY>(docClientHeight-winY))&&(winY>winHeight)) {
			winY=winY-winHeight;
		} else if (((docClientHeight-winY)>winY)&&((docClientHeight-winY)>winHeight)) {
			winY=winY;
		} else {
			winY=(docClientHeight-winHeight)/2;
		}
		
		var docClientWidth=document.body.clientWidth;
		if (winX>(docClientWidth-winX)) {
			if (winWidth>(winX-200)){
				winWidth=winX-200;
			}
			winX=winX-winWidth;
		} else {
			if (winWidth>(docClientWidth-winX-200)){
				winWidth=docClientWidth-winX-200;
			}
		}
		
		win = new Ext.Window({
				//id : 'win',   //by wuqk 2012-02-22
				width : 400,
				height : winHeight,
				x : winX,
				y : winY,     //removed by wuqk 2010-11-17
				resizable : false,
				closable : true,
				autoScroll:true,
				animCollapse : true,
				html:template,
				renderTo : document.body,
				layout : 'fit',
				modal : true,
				title : winTitleSub,
				bbar: ['-'
		        	,{
						xtype:"checkbox"
						,id : 'chkSelAllOE'
						,boxLabel:"全选\反选"
						,listeners:{
							'check': function(){
								var chkItems=document.getElementsByName("CHECK_ITEM");
								for (i=0;i<chkItems.length;i++){
									var checkObj=chkItems[i];
									if (checkObj.type=="checkbox"){
										checkObj.checked = Ext.getCmp('chkSelAllOE').checked;
									}
								}
							}
					    }
					},'-'
				],
				buttons : [{
					id : 'btnConfirm',
					text : '确定',
					iconCls : 'icon-confirm',
					listeners : {
						"click" : function(){
							var chkItems=document.getElementsByName("CHECK_ITEM");
							var idList="";
							for (i=0;i<chkItems.length;i++){
								var checkObj=chkItems[i];
								if (checkObj.type=="checkbox"){
									if (checkObj.checked) {
										idList+=checkObj.id+",";
									}
								}
							}
							if (idList==""){
								objInp.value="";
								objInp.checked=false;
							}else{
								objInp.checked=true;
								objInp.value=idList.substring(0,idList.length-1);
							}
							winFlag=1;
							win.close();
							onOrderEntryClick();      //add by wuqk 2011-12-28
						}
					}
				},{
					id : 'btnCancel',
					text : '取消',
					iconCls : 'icon-undo',
					listeners : {
						"click" : function(){
							objInp.value="";
							objInp.checked=false;
							winFlag=1;
							win.close();
						}
					}
				}],
				listeners :{
					"beforeclose" : function(){
						if (winFlag=="0"){
							objInp.value="";
							objInp.checked=false;
						}
					},
					'beforeshow' : function(){
						var chkItems=document.getElementsByName("CHECK_ITEM");
						for (var i=0;i<chkItems.length;i++){
							var checkObj=chkItems[i];
							if (checkObj.type=="checkbox"){
								checkObj.onclick=onArcimCheckClick;
							}
						}
					}
				}
		});
		win.show();
	}
	
	//检查关联医嘱选择问题处理(选择一条,一组都自动选中)
	function onArcimCheckClick(){
		var tmpList0=this.id.split("^");
		var chkItems=document.getElementsByName("CHECK_ITEM");
		for (var i=0;i<chkItems.length;i++){
			var checkObj=chkItems[i];
			if (checkObj.type=="checkbox"){
				var tmpList1=checkObj.id.split("^");
				if ((tmpList1[0]==tmpList0[0])&&(tmpList1[2]==tmpList0[2])){
					checkObj.checked=this.checked;
				}
			}
		}
	}
	
	//弹出执行诊疗(护理)窗体再选择项目事件
	function onExecClick(objInp,evt,winTitleSub){
		if (!objInp.checked) return;
		
		var winFlag=0;
		var childrenItems=objInp.parentElement.parentElement.getElementsByTagName("span");
		var childLen=childrenItems.length;
		var rows=0;
		var tempItems="";
		var template = '<table>';
		for (var ind=0;ind<childLen;ind++){
			node=childrenItems[ind];
			itemString = '<tr><td>';
			
			tempItems=node.id;
			itemString+='<input type="checkbox" name="CHECK_ITEM" checked id="';
			itemString+=node.id;
			itemString+='">';
			
			itemString+='</td>'
			itemString+='<td colspan="2">'
			itemString+=node.outerHTML;
			itemString+='</td></tr>';
			rows+=1;
			
			template+=itemString;
		}
		template+='</table>';
		
		if (rows==1) {      //本组单项且只包含一个项目，修改checkbox的value
			objInp.value=tempItems;
			return;
		}
		var winHeight=rows*30+85;
		var winWidth=400;
		var winX=evt.clientX;
		var winY=evt.clientY;
		
		var docClientHeight=document.body.clientHeight;
		if (winHeight>(docClientHeight-100))
		{
			winHeight=docClientHeight-100;
		}
		if ((winY>(docClientHeight-winY))&&(winY>winHeight)) {
			winY=winY-winHeight;
		} else if (((docClientHeight-winY)>winY)&&((docClientHeight-winY)>winHeight)) {
			winY=winY;
		} else {
			winY=(docClientHeight-winHeight)/2;
		}
		
		var docClientWidth=document.body.clientWidth;
		if (winX>(docClientWidth-winX)) {
			if (winWidth>(winX-200)){
				winWidth=winX-200;
			}
			winX=winX-winWidth;
		} else {
			if (winWidth>(docClientWidth-winX-200)){
				winWidth=docClientWidth-winX-200;
			}
		}
		
		win = new Ext.Window({
				//id : 'win',   //by wuqk 2012-02-22
				width : 400,
				height : winHeight,
				x : winX,
				y : winY,     //removed by wuqk 2010-11-17
				resizable : false,
				closable : true,
				autoScroll:true,
				animCollapse : true,
				html:template,
				renderTo : document.body,
				layout : 'fit',
				modal : true,
				title : winTitleSub,
				buttons : [{
					id : 'btnConfirm',
					text : '确定',
					iconCls : 'icon-confirm',
					listeners : {
						"click" : function(){
							var chkItems=document.getElementsByName("CHECK_ITEM");
							var idList="";
							for (i=0;i<chkItems.length;i++){
								var checkObj=chkItems[i];
								if (checkObj.type=="checkbox"){
									if (checkObj.checked) {
										idList+=checkObj.id+",";
									}
								}
							}
							if (idList==""){
								objInp.value="";
								objInp.checked=false;
							}else{
								objInp.checked=true;
								objInp.value=idList.substring(0,idList.length-1);
							}
							winFlag=1;
							win.close();
						}
					}
				},{
					id : 'btnCancel',
					text : '取消',
					iconCls : 'icon-undo',
					listeners : {
						"click" : function(){
							objInp.value="";
							objInp.checked=false;
							winFlag=1;
							win.close();
						}
					}
				}],
				listeners :{
					"beforeclose" : function(){
						if (winFlag=="0"){
							objInp.value="";
							objInp.checked=false;
						}
					}
				}
		});
		win.show();
	}
	
	//弹出撤销诊疗(护理,门诊医嘱)窗体再选择项目事件
	function onUpdoClick(objInp,evt,winTitleSub){
		if (!objInp.checked) return;
		
		var winFlag=0;
		var childrenItems=objInp.parentElement.parentElement.getElementsByTagName("span");
		var childLen=childrenItems.length;
		var rows=0;
		var tempItems="";
		
		var template = '<table>';
		for (var ind=0;ind<childLen;ind++){
			node=childrenItems[ind];
			var arrayImpl=GetImplements(PathWayID,node.id);
			if (arrayImpl.length==0) {
				continue                                     //无实施记录
			}else{
				itemString = '<tr><td>';
				
				if (arrayImpl.length>1) {                    //包含多条实施记录
					itemString+=separete;
				} else if (arrayImpl.length==1) {            //包含一条实施记录
					itemString+=separete;
				} else { }                                   //无实施记录
				itemString+='</td>';
				itemString+='<td colspan="2">';
				itemString+=node.outerHTML;
				itemString+='</td></tr>';
				rows+=1;
				if (arrayImpl.length>=1){
					for (var indexImpl=0;indexImpl<arrayImpl.length;indexImpl++){
						rows+=1;
						var objItemImpl=arrayImpl[indexImpl];
						itemString+='<tr><td>'+separete+'</td><td>';
						if (objItemImpl.ImplID!='')
						{
							itemString+='<input type="checkbox" name="CHECK_ITEM"';
							itemString+=' id="'+objItemImpl.ImplID+'">';
						}
						itemString+='<td><span><i>'+objItemImpl.ImplDesc+'</i></span></td>';
						itemString+='</tr>';
					}
				}
				template+=itemString;
			}
		}
		template+='</table>';
		
		if (rows<1) {        //只包含一条实施记录或不包含实时记录，修改checkbox的value
			objInp.value=tempItems;
			if (!tempItems) { objInp.checked=false; }
			return;
		} else {
			var winHeight=rows*30+85;
			var winWidth=400;
			var winX=evt.clientX;
			var winY=evt.clientY;
			
			var docClientHeight=document.body.clientHeight;
			if (winHeight>(docClientHeight-100))
			{
				winHeight=docClientHeight-100;
			}
			if ((winY>(docClientHeight-winY))&&(winY>winHeight)) {
				winY=winY-winHeight;
			} else if (((docClientHeight-winY)>winY)&&((docClientHeight-winY)>winHeight)) {
				winY=winY;
			} else {
				winY=(docClientHeight-winHeight)/2;
			}
			
			var docClientWidth=document.body.clientWidth;
			if (winX>(docClientWidth-winX)) {
				if (winWidth>(winX-200)){
					winWidth=winX-200;
				}
				winX=winX-winWidth;
			} else {
				if (winWidth>(docClientWidth-winX-200)){
					winWidth=docClientWidth-winX-200;
				}
			}
			
			win = new Ext.Window({
					//id : 'win',   //by wuqk 2012-02-22
					width : 400,
					height : winHeight,
					x : winX,
					y : winY,
					resizable : false,
					closable : true,
					autoScroll:true,
					animCollapse : true,
					html:template,
					renderTo : document.body,
					layout : 'fit',
					modal : true,
					title : winTitleSub,
					buttons : [{
						id : 'btnConfirm',
						text : '确定',
						iconCls : 'icon-confirm',
						listeners : {
							"click" : function(){
								var chkItems=document.getElementsByName("CHECK_ITEM");
								var idList="";
								for (i=0;i<chkItems.length;i++){
									var checkObj=chkItems[i];
									if (checkObj.type=="checkbox"){
										if (checkObj.checked) {
											idList+=checkObj.id+",";
										}
									}
								}
								if (idList==""){
									//
								}else{
									var selectItems=idList.substring(0,idList.length-1);
									updoCPWImpl(selectItems);
								}
								objInp.value="";
								objInp.checked=false;
								winFlag=1;
								win.close();
							}
						}
					},{
						id : 'btnCancel',
						text : '取消',
						iconCls : 'icon-undo',
						listeners : {
							"click" : function(){
								objInp.value="";
								objInp.checked=false;
								winFlag=1;
								win.close();
							}
						}
					}],
					listeners :{
						"beforeclose" : function(){
							if (winFlag=="0"){
								objInp.value="";
								objInp.checked=false;
							}
						}
					}
			});
			win.show();
		}
	}
	
	//执行诊疗(护理)
	function onExecEntryClick(){
		//CPW_CONSULT_ITEM
		selectItems="";
		var cpwConsultItems=document.getElementsByName("CPW_CONSULT_ITEM");
  		for (i=0;i<cpwConsultItems.length;i++){
  			var checkObj=cpwConsultItems[i];
  			if (checkObj.type=="checkbox"){
  				if (checkObj.checked){
  					selectItems+=checkObj.value+",";
  				}
  			}
  		}
  		
  		//CPW_NURSE_ITEM
  		var cpwNurseItems=document.getElementsByName("CPW_NURSE_ITEM");		
  		for (i=0;i<cpwNurseItems.length;i++){
  			var checkObj=cpwNurseItems[i];
  			if (checkObj.type=="checkbox"){
  				if (checkObj.checked){
  					selectItems+=checkObj.value+",";
  				}
  			}
  		}
  		
  		//CPW_OE_ITEM
  		var cpwNurseItems=document.getElementsByName("CPW_OE_ITEM");		
  		for (i=0;i<cpwNurseItems.length;i++){
  			var checkObj=cpwNurseItems[i];
  			if (checkObj.type=="checkbox"){
  				if (checkObj.checked){
  					selectItems+=checkObj.value+",";
  				}
  			}
  		}
  		
  		//CPW_NE_ITEM
  		var cpwNurseItems=document.getElementsByName("CPW_NE_ITEM");		
  		for (i=0;i<cpwNurseItems.length;i++){
  			var checkObj=cpwNurseItems[i];
  			if (checkObj.type=="checkbox"){
  				if (checkObj.checked){
  					selectItems+=checkObj.value+",";
  				}
  			}
  		}
  		
  		if (selectItems!="") selectItems=selectItems.substring(0,selectItems.length-1);
  		//alert(selectItems);
  		doCPWImpl();
	}
	
	//下医嘱(护嘱)返回选择项目事件，并执行回调函数
	function onOrderEntryClick(){
		selectItems="";
		
		var cpwOrdItems=document.getElementsByName("CPW_OE_SELALL");
		for (i=0;i<cpwOrdItems.length;i++){
			var checkObj=cpwOrdItems[i];
			if (checkObj.type=="checkbox"){
				if (checkObj.checked){
  					selectItems+=checkObj.value+",";
  					checkObj.value="";
  				}
			}
		}
		var cpwOrdItems=document.getElementsByName("CPW_NE_SELALL");
		for (i=0;i<cpwOrdItems.length;i++){
			var checkObj=cpwOrdItems[i];
			if (checkObj.type=="checkbox"){
				if (checkObj.checked){
  					selectItems+=checkObj.value+",";
  					checkObj.value="";
  				}
			}
		}
		
		var cpwOrdItems=document.getElementsByName("CPW_OE_ITEM");
  		for (i=0;i<cpwOrdItems.length;i++){
  			var checkObj=cpwOrdItems[i];
  			if (checkObj.type=="checkbox"){
  				if (checkObj.checked){
  					selectItems+=checkObj.value+",";
  					checkObj.value="";
  				}
  			}
  		}
  		
  		var cpwOrdItems=document.getElementsByName("CPW_NE_ITEM");
  		for (i=0;i<cpwOrdItems.length;i++){
  			var checkObj=cpwOrdItems[i];
  			if (checkObj.type=="checkbox"){
  				if (checkObj.checked){
  					selectItems+=checkObj.value+",";
  					checkObj.value="";
  				}
  			}
  		}
  		
  		if ((OEOrderFlag==1)||(NEOrderFlag==1)){
  			if (selectItems!="") selectItems=selectItems.substring(0,selectItems.length-1);
  			//ShowCallBack(selectItems);
  			
  			//add by wuqk 2011-12-28 for orderEntry
			/*
			var docOrderEntry = document.getElementById("docOrderEntry");
			var winDocOrderEntry=docOrderEntry.contentWindow;
			winDocOrderEntry.addOEORIByCPW(selectItems);*/
			
			var strOrderList = selectItems;
			
			//add by wuqk 2012-03-06 医生站医嘱录入修改
			var ifrmDocOrderEntry = document.getElementById("docOrderEntry");
			if (typeof ifrmDocOrderEntry.contentWindow.addOEORIByCPW =="function"){
				ifrmDocOrderEntry.contentWindow.addOEORIByCPW(strOrderList);
			} else {
				var frameOrderEntry = ifrmDocOrderEntry.contentWindow.frames["oeorder_entry"];
				if (frameOrderEntry){
					if (typeof frameOrderEntry.window.addOEORIByCPW =="function") {
						frameOrderEntry.addOEORIByCPW(strOrderList);
					}
				} else {
					var ifrmOrderEntrySub = ifrmDocOrderEntry.contentWindow.document.getElementById("OrderEdit");
					if (typeof ifrmOrderEntrySub.contentWindow.addOEORIByCPW =="function"){
						ifrmOrderEntrySub.contentWindow.addOEORIByCPW(strOrderList);
					} else {
						alert("医嘱录入模块升级导致结构变化,请调整!");
					}
				}
			}
  		}
	}
	
	//增加实时记录
	function doCPWImpl(){
		if (selectItems=="") return;
		var service = ExtTool.StaticServerObject("web.DHCCPW.MR.Implement");
		var ret=service.doImplBatch(PathWayID,selectItems,session['LOGON.USERID']);
		//alert(ret);
		if (ret) {
			/*
			////loaddata-wuqk  --增加实施记录后刷新--
			var xdata=GetFormData(PathWayID,CPWID);
			tpl2.compile();
			tpl2.overwrite(formPanel.body,xdata);
			formPanel.doLayout();
			Container.doLayout();*/
			//obj.formShowData(FORM_PageMode,0);
			obj.formShowData(FORM_PageMode,combStepList.getValue());	//update by liuyh 2016-8-18 增加实施记录时刷新本阶段页面
			
			//loadEvent();
		}
	}
	
	//撤销实施记录
	function updoCPWImpl(selectItems){
		if (selectItems=="") return;
		var service = ExtTool.StaticServerObject("web.DHCCPW.MR.Implement");
		var ret=service.updoImplBatch(selectItems,session['LOGON.USERID']);
		//alert(ret);
		if (ret) {
			/*
			////loaddata-wuqk  --撤销实施记录后刷新--
			var xdata=GetFormData(PathWayID,CPWID);
			tpl2.compile();
			tpl2.overwrite(formPanel.body,xdata);
			formPanel.doLayout();
			Container.doLayout();*/
			obj.formShowData(FORM_PageMode,0);
			//loadEvent();
		}
	}
	
	function updateEstimate(inputStr){
		var serviceEstimate=ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysEstimate");
		var ret=serviceEstimate.Update(inputStr);
		if (ret>0) {
			/*
			////loaddata-wuqk  --调整步骤时间后刷新--
			var xdata=GetFormData(PathWayID,CPWID);
			tpl2.compile();
			tpl2.overwrite(formPanel.body,xdata);
			formPanel.doLayout();
			Container.doLayout();
			loadEvent();*/
			
			window.location.reload();
		}else{
			if (ret=='-2.1') {
				ExtTool.alert("提示","开始时间大于结束时间,请重新调整时间!");
			}else if (ret=='-2.2') {
				ExtTool.alert("提示","开始时间大于入院时间,请重新调整时间!");
			}else{
				ExtTool.alert("提示","系统错误!ErrorCode="+ret);
			}
		}
	}
	
	//Modify by wuqk 2011-12-27
	//  add argument:showStepId  显示步骤Id
	//  
	function GetFormData(PathWayID,CPWID,showStepId){
		
		var xcomplist=serviceFormShow.BuildJsonCompList(PathWayID);
		if (xcomplist=='') xcomplist="["+xcomplist+"]"
		var xcomplist=Ext.util.JSON.decode(xcomplist);
		var xconsult="",yconsult="";
		var xorder="",yorder="";
		var xnursing="",ynursing="";
		var xvariance="",yvariance="";
		var xdoctorsign="",ydoctorsign="";
		var xnursesign="",ynursesign="";
		var xsyndrome = new Array(xcomplist.length);
		var ysyndrome = new Array(xcomplist.length);
		for (var compIndex=0;compIndex<xcomplist.length;compIndex++){
				xsyndrome[compIndex]="";
				ysyndrome[compIndex]="";
		}
		
		//时间调整
		var xepstepsest=serviceFormShow.BuildJsonEpStepsEst(PathWayID,CPWID);
		if (xepstepsest=="") xepstepsest="[]";
		xepstepsest=Ext.util.JSON.decode(xepstepsest);
		
		var epsteps;
		var epstepsest;
		if (showStepId==0){
			epsteps=xepsteps
			epstepsest=xepstepsest
		}
		else{
			epsteps=[];
			epstepsest=[];
		}
		
		var ystepid="";
		for (var indep=0;indep<xepsteps.length;indep++)
		{
			ystepid=xepsteps[indep].stepid;
			
			//add by wuqk 2011-12-27
			//showStepId=0时显示所有步骤
			//否则只显示showStepId指定的步骤
			if ((ystepid!=showStepId)&&(showStepId!=0)) {continue;} 
			if (ystepid==showStepId){
				epsteps[0]=xepsteps[indep];
				epstepsest[0]=xepstepsest[indep];
			}
			
			yconsult=serviceFormShow.BuildJsonEpStepItems(PathWayID,ystepid,"01");
			if (yconsult=="") {yconsult="[]";}
			if (xconsult) {xconsult=xconsult+",";}
			xconsult=xconsult+yconsult;
			
			yorder=serviceFormShow.BuildJsonEpStepItems(PathWayID,ystepid,"02");
			if (yorder=="") {yorder="[]";}
			if (xorder) {xorder=xorder+",";}
			xorder=xorder+yorder;
			
			ynursing=serviceFormShow.BuildJsonEpStepItems(PathWayID,ystepid,"03");
			if (ynursing=="") {ynursing="[]";}
			if (xnursing) {xnursing=xnursing+",";}
			xnursing=xnursing+ynursing;
			
			yvariance=serviceFormShow.BuildJsonEpStepVars(PathWayID,ystepid);
			if (yvariance=="") {yvariance="[]";}
			if (xvariance) {xvariance=xvariance+",";}
			xvariance=xvariance+yvariance;
			
			ydoctorsign=serviceFormShow.BuildJsonEpStepSigns(PathWayID,ystepid,"D");
			if (ydoctorsign=="") {ydoctorsign="[]";}
			if (xdoctorsign) {xdoctorsign=xdoctorsign+",";}
			xdoctorsign=xdoctorsign+ydoctorsign;
			
			ynursesign=serviceFormShow.BuildJsonEpStepSigns(PathWayID,ystepid,"N");
			if (ynursesign=="") {ynursesign="[]";}
			if (xnursesign) {xnursesign=xnursesign+",";}
			xnursesign=xnursesign+ynursesign;
			
			for (var compIndex=0;compIndex<xcomplist.length;compIndex++){
				ysyndrome[compIndex]=serviceFormShow.BuildJsonCompItems(PathWayID,ystepid,xcomplist[compIndex].compcpwid);
				if (ysyndrome[compIndex]=="") {
					ysyndrome[compIndex]="{'stepid':'"+ystepid+"','stepdata':[]}";
				}
				if (xsyndrome[compIndex]) {xsyndrome[compIndex]=xsyndrome[compIndex]+",";}
				xsyndrome[compIndex]=xsyndrome[compIndex]+ysyndrome[compIndex];
			}
		}
		xconsult=Ext.util.JSON.decode("["+xconsult+"]");
		xorder=Ext.util.JSON.decode("["+xorder+"]");
		xnursing=Ext.util.JSON.decode("["+xnursing+"]");
		xvariance=Ext.util.JSON.decode("["+xvariance+"]");
		xdoctorsign=Ext.util.JSON.decode("["+xdoctorsign+"]");
		xnursesign=Ext.util.JSON.decode("["+xnursesign+"]");
		//aa;
		//var syndrome=Ext.util.JSON.decode("[{	desc:'并发症1',	step:["+xorder+"]}]");
		var syndrome="";
		for (var compIndex=0;compIndex<xcomplist.length;compIndex++){
			if (syndrome=='') {
				syndrome="{	desc:'"+xcomplist[compIndex].compcpwdesc+"',	step:["+xsyndrome[compIndex]+"]}"
			}else{
				syndrome=syndrome+","+"{	desc:'"+xcomplist[compIndex].compcpwdesc+"',	step:["+xsyndrome[compIndex]+"]}"
			}
		}
		//bb;
		syndrome=Ext.util.JSON.decode("["+syndrome+"]");
		
		var xdata={
			'head': epsteps,
			'estimate' : epstepsest,
			'consult': xconsult,
			'order': xorder,
			'nursing': xnursing,
			'variance': xvariance,
			'doctorsign': xdoctorsign,
			'nursesign': xnursesign,
			'syndrome':syndrome
		}
		
		//add by zf 20120214
		//判断是否存在必选未执行项目,如果存在,显示闪动图标
		var isDisplayIcon=false;
		var btnNotFinish=Ext.getCmp("btnNotFinish");
		if (btnNotFinish)
		{
			btnNotFinish.setVisible(false);
			for (var indStep1=0; indStep1<epsteps.length; indStep1++)
			{
				if (isDisplayIcon) break;
				var objStep1=epsteps[indStep1];
				if ((objStep1.iscurrstep=='1')||(objStep1.isoverstep=='1'))
				{
					if (IsDisplayIcon(objStep1,xconsult))
					{
						btnNotFinish.setVisible(true);
					} else if (IsDisplayIcon(objStep1,xorder)) {
						btnNotFinish.setVisible(true);
					} else if (IsDisplayIcon(objStep1,xnursing)) {
						btnNotFinish.setVisible(true);
					} else {
						
					}
				}
			}
		}
		
		//取所有步骤列表
		var tmpFORM_STEP_LIST=serviceFormShow.BuildJsonEpSteps(PathWayID,CPWID);
		if (tmpFORM_STEP_LIST=="") return null;
		FORM_STEP_LIST = Ext.util.JSON.decode(tmpFORM_STEP_LIST);      // stepid,stepdesc,iscurrstep
		
		return xdata;
	}
	
	
	function IsDisplayIcon(objStep1,objItemList)
	{
		var isDisplayIcon=false;
		for (var indStep=0; indStep<objItemList.length; indStep++)
		{
			var objStep=objItemList[indStep];
			if (objStep.stepid!=objStep1.stepid) { continue; }
			var objStepData=objStep.stepdata;
			for (var indStepData=0; indStepData<objStepData.length; indStepData++)
			{
				var objSubCate=objStepData[indStepData];
				var objSubCateData=objSubCate.subcatedata;
				for (var indSubCateData=0; indSubCateData<objSubCateData.length; indSubCateData++)
				{
					var objGroup=objSubCateData[indSubCateData];
					var objGroupData=objGroup.groupdata;
					for (var indGroupData=0; indGroupData<objGroupData.length; indGroupData++)
					{
						var objItem=objGroupData[indGroupData];
						if ((objItem.optional=='0')&&(objItem.impl=='0'))
						{
							return true;
						}
					}
				}
			}
		}
		return false;
	}
	
	function BuildTitle(objPerson,objStep){
		var formTitle="<b>登记号:</b>" + objPerson.PapmiNo;
		formTitle = formTitle + separete + "<b>姓名:</b>"+objPerson.PatName;
		formTitle = formTitle + separete + "<b>性别:</b>"+objPerson.PatSex;
		formTitle = formTitle + separete + "<b>年龄:</b>"+objPerson.Age;
		formTitle = formTitle + separete + "<b>就诊日期:</b>"+objPaadm.AdmDate;
		formTitle = formTitle + separete + ""+objPaadm.AdmTime;
		formTitle = formTitle + separete + "";
		formTitle = formTitle + separete + "<b>当前路径:</b>"+objCPW.CPWDesc;
		if (objStep) {
			//formTitle = formTitle + separete + "入院第"+objStep.admDateNo+"日";
			//formTitle = formTitle + separete + "入径第"+objStep.cpwDateNo+"日";
			//formTitle = formTitle + separete + "当前步骤:"+objStep.currentStepDesc;
			//formTitle = formTitle + separete + "当前步骤第"+objStep.currentStepDayNo+"日";
		}
		return formTitle;
	}
	function BuildTitleObject(objPerson,objStep,objCPW,objPathWay){
		var objTitle = new Object();
		if (objPerson) {
			objTitle.RegNo = "<b>登记号:</b>" + objPerson.PapmiNo;
			objTitle.PatName = "<b>姓名:</b>"+objPerson.PatName;
			objTitle.PatSex = "<b>性别:</b>"+objPerson.PatSex;
			objTitle.PatAge = "<b>年龄:</b>"+objPerson.Age;
		} else {
			objTitle.RegNo = "";
			objTitle.PatName = "";
			objTitle.PatSex = "";
			objTitle.PatAge = "";
		}
		if (objPaadm) {
			objTitle.AdmDate = "<b>就诊日期:</b>"+objPaadm.AdmDate;
			objTitle.AdmTime = ""+objPaadm.AdmTime;
			objTitle.AdmDateTime = "<b>就诊时间:</b>"+objPaadm.AdmDate+" "+objPaadm.AdmTime;
			objTitle.AdmDoc = "";
		} else {
			objTitle.AdmDate = "";
			objTitle.AdmTime = "";
			objTitle.AdmDateTime = "";
			objTitle.AdmDoc = "";
		}
		if (objStep) {
			objTitle.admDateNo = "<b>入院第"+objStep.admDateNo+"日</b>";
		} else {
			objTitle.admDateNo = "";
		}
		if (objCPW) {
			objTitle.CPWDesc = "<b>当前路径:</b>"+objCPW.CPWDesc;
		} else {
			objTitle.CPWDesc = "";
		}
		if (objPathWay) {
			objTitle.InDateTime = "<b>入径时间:</b>"+objPathWay.InDate+" "+objPathWay.InTime;
			objTitle.InDoctorDesc = "<b>入径人:</b>"+objPathWay.InDoctorDesc;
		} else {
			objTitle.InDateTime = "";
			objTitle.InDoctorDesc = "";
		}
		return objTitle;
	}
	
	//add by wuqk  2011-12-29
	//构造 变异记录页面
	function BuildVarFormPanel(){
		var objVarForm = new Object();
		objVarForm.cboVarCategStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
			}));
		objVarForm.cboVarCategStore = new Ext.data.Store({
			proxy: objVarForm.cboVarCategStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'Rowid'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'Rowid', mapping: 'Rowid'}
				,{name: 'Code', mapping: 'Code'}
				,{name: 'Desc', mapping: 'Desc'}
			])
		});
		objVarForm.cboVarCateg = new Ext.form.ComboBox({
			width : 100
			,displayField : 'Desc'
			,minChars : 1
			,fieldLabel : '变异类型'
			,store : objVarForm.cboVarCategStore
			,editable : true
			,triggerAction : 'all'
			,anchor : '95%'
			,valueField : 'Rowid'
		});
		objVarForm.cboVarCategStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCCPW.MRC.VarianceCategory';
				param.QueryName = 'QryVarCateg';
				param.Arg1 = "V";
				param.ArgCnt = 1;
		});
		objVarForm.cboVarCategStore.load({});
		objVarForm.cboVarReasonStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
			}));
		objVarForm.cboVarReasonStore = new Ext.data.Store({
			proxy: objVarForm.cboVarReasonStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'Rowid'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'Rowid', mapping: 'Rowid'}
				,{name: 'Code', mapping: 'Code'}
				,{name: 'Desc', mapping: 'Desc'}
			])
		});
		objVarForm.cboVarReason = new Ext.form.ComboBox({
			width : 100
			,displayField : 'Desc'
			,minChars : 1
			,fieldLabel : '变异原因'
			,store : objVarForm.cboVarReasonStore
			,editable : true
			,triggerAction : 'all'
			,anchor : '95%'
			,valueField : 'Rowid'
		});
		objVarForm.cboVarReasonStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCCPW.MRC.VarianceReason';
				param.QueryName = 'QryVarReasonNew';
				param.Arg1 = objVarForm.cboVarCateg.getValue();
				param.ArgCnt = 1;
		});
		//objWin.cboVarReasonStore.load({});
		objVarForm.txtaVarResume = new Ext.form.TextArea({
			height : 80
			,width : 100
			,fieldLabel : '备注'
			,anchor : '95%'
		});
		objVarForm.ConditionPanel = new Ext.Panel({
			buttonAlign : 'center'
			,labelAlign : 'right'
			,labelWidth : 70
			,bodyBorder : 'padding:0 0 0 0'
			,layout : 'form'
			,frame : true
			,items:[
				objVarForm.cboVarCateg
				,objVarForm.cboVarReason
				,objVarForm.txtaVarResume
			]
		});
		
		objVarForm.cboVarCategStore.load({});
		//objVarForm.cboVarCateg_OnCollapse = function(){
		//	objVarForm.cboVarReason.clearValue();
		//}
		//objVarForm.cboVarReason_OnExpand = function(){
			//objVarForm.cboVarReason.clearValue();
		//	objVarForm.cboVarReasonStore.load({});
		//}	
		objVarForm.cboVarCateg_OnSelect = function(){
			objVarForm.cboVarReason.clearValue();
			objVarForm.cboVarReasonStore.load({});
		}
		//objVarForm.cboVarCateg.on("expand", objVarForm.cboVarCateg_OnExpand, objVarForm);
		//objVarForm.cboVarCateg.on("collapse", objVarForm.cboVarCateg_OnCollapse, objVarForm);
		objVarForm.cboVarCateg.on("select", objVarForm.cboVarCateg_OnSelect, objVarForm);
		objVarForm.cboVarReason.on("expand", objVarForm.cboVarReason_OnExpand, objVarForm);
					
		return objVarForm;
	}
	function BuildOrderEntryURL(){
		var objGetWKFLI = ExtTool.StaticServerObject("web.DHCCPW.MR.Interface");
		var TWKFL=objGetWKFLI.GetWorkflowID("DHCCPW.OrderEntry");
		if (TWKFL!='') {
			var objSysBaseSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.SysBaseSrv");
			var flg=objSysBaseSrv.CopyPreferencesToCPWWF(session['LOGON.SITECODE'],session['LOGON.USERID'],session['LOGON.GROUPID'],session['LOGON.CTLOCID'],session['LOGON.HOSPID']);
			if (flg)
			{
				/* //旧版医嘱录入调用页面
				var orderEntry = "websys.csp?"  //ChartID=21
				orderEntry +="&PatientID=" + objPaadm.PatientID;
				orderEntry +="&EpisodeID=" + EpisodeID;
				orderEntry +="&mradm=" + MRAdm;
				orderEntry +="&ChartID=" + ChartID;
				orderEntry +="&EpisodeIDs=";
				orderEntry +="&PAAdmTransactionID=";
				orderEntry +="&OperRoomID=";
				orderEntry +="&DischID=";
				orderEntry +="&CurrDischID=";
				orderEntry +="&DischEpisodes=";
				orderEntry +="&doctype=";
				orderEntry +="&Random=";
				orderEntry +="&TWKFL=" + TWKFL;
				*/
				
				//新版医嘱录入调用页面
				var orderEntry = "websys.csp?TDIRECTPAGE=oeorder.entrysinglelogon.csp"
				orderEntry +="&PatientID=" + objPaadm.PatientID;
				orderEntry +="&EpisodeID=" + EpisodeID;
				orderEntry +="&EpisodeIDs=";
				orderEntry +="&mradm=" + MRAdm;
				orderEntry +="&ChartID=";
				orderEntry +="&PAAdmTransactionID=";
				orderEntry +="&OperRoomID=";
				orderEntry +="&DischID=";
				orderEntry +="&CurrDischID=";
				orderEntry +="&DischEpisodes=";
				orderEntry +="&doctype=";
				orderEntry +="&TWKFL=";
				orderEntry +="&TWKFLI=";
				orderEntry +="&TimeLine=";
				orderEntry +="&ConsultID=";
				orderEntry +="&ConsultEpisodeID=" + EpisodeID;
				orderEntry +="&copyOeoris=";
				orderEntry +="&copyTo=";
				orderEntry +="&NotShowPABannerFlag=1";
			}
		} else {
			// 航天中心医院及使用Medtrak系统医院
			var TWKFL=objGetWKFLI.GetWorkflowID("DHCCPW.OrderList");
			if (TWKFL!='') {
				/* //旧版医嘱录入调用页面
				var orderEntry = "websys.csp?"  //ChartID=21
				orderEntry +="&PatientID=" + objPaadm.PatientID;
				orderEntry +="&EpisodeID=" + EpisodeID;
				orderEntry +="&mradm=" + MRAdm;
				orderEntry +="&ChartID=" + ChartID;
				orderEntry +="&EpisodeIDs=";
				orderEntry +="&PAAdmTransactionID=";
				orderEntry +="&OperRoomID=";
				orderEntry +="&DischID=";
				orderEntry +="&CurrDischID=";
				orderEntry +="&DischEpisodes=";
				orderEntry +="&doctype=";
				orderEntry +="&Random=";
				orderEntry +="&TWKFL=" + TWKFL;
				*/
				
				//新版医嘱录入调用页面
				var orderEntry = "websys.csp?TDIRECTPAGE=oeorder.entrysinglelogon.csp"
				orderEntry +="&PatientID=" + objPaadm.PatientID;
				orderEntry +="&EpisodeID=" + EpisodeID;
				orderEntry +="&EpisodeIDs=";
				orderEntry +="&mradm=" + MRAdm;
				orderEntry +="&ChartID=";
				orderEntry +="&PAAdmTransactionID=";
				orderEntry +="&OperRoomID=";
				orderEntry +="&DischID=";
				orderEntry +="&CurrDischID=";
				orderEntry +="&DischEpisodes=";
				orderEntry +="&doctype=";
				orderEntry +="&TWKFL=";
				orderEntry +="&TWKFLI=";
				orderEntry +="&TimeLine=";
				orderEntry +="&ConsultID=";
				orderEntry +="&ConsultEpisodeID=" + EpisodeID;
				orderEntry +="&copyOeoris=";
				orderEntry +="&copyTo=";
				orderEntry +="&NotShowPABannerFlag=1";
			}
		}
		return orderEntry;
	}
	function GetEpisodeID(argMRAdm){
		var objBasePAADMSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.PAADMSrv");
		var ret = objBasePAADMSrv.GetEpisodeID(argMRAdm);
		return ret;
	}
	
	function GetDHCPAADM(argEpisodeID){
		var objBasePAADMSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.PAADMSrv");
		if (argEpisodeID){
			var ret = objBasePAADMSrv.GetAdmInfoByID(argEpisodeID,CHR_1);
			if (ret!=""){
				var arrItems=ret.split(CHR_1);
				var objPaadm=new DHCPAADM();
				objPaadm.EpisodeID = arrItems[0];
				objPaadm.AdmType = arrItems[1];
				objPaadm.AdmDate = arrItems[2];
				objPaadm.AdmTime = arrItems[3];
				objPaadm.AdmDoc = arrItems[4];
				objPaadm.AdmLoc = arrItems[5];
				objPaadm.AdmWard = arrItems[6];
				objPaadm.AdmRoom = arrItems[7];
				objPaadm.AdmBed = arrItems[8];
				objPaadm.AdmStatus = arrItems[9];
				objPaadm.DischDate = arrItems[10];
				objPaadm.DischTime = arrItems[11];
				objPaadm.MRAdm = arrItems[12];
				objPaadm.PatientID = arrItems[13];
				return objPaadm;
			}
		}
		return null;
	}
	
	function GetDHCPaPerson(argPatientID){
		var objBasePaPatmasSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.PaPatmasSrv");
		if (argPatientID){
			var ret = objBasePaPatmasSrv.GetPatInfoByID(argPatientID,"",CHR_1);
			if (ret!=""){
				var arrItems=ret.split(CHR_1);
				var objPaPerson=new DHCPaPerson();
				objPaPerson.PatientID = arrItems[0];
				objPaPerson.PapmiNo = arrItems[1];
				objPaPerson.PatName = arrItems[2];
				objPaPerson.PatSex = arrItems[3];
				objPaPerson.BirthDay = arrItems[4];
				objPaPerson.Age = arrItems[5];
				return objPaPerson;
			}
		}
		return null
	}
	
	function GetClinPathWayDic(cpwRowid){
		//##Class(web.DHCCPW.MRC.ClinPathWaysSrv).GetById(9)
		var objCPWService = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysSrv");
		var ret = objCPWService.GetById(cpwRowid,CHR_1);
		if (ret!=""){
			var arrItems=ret.split(CHR_1);
			var objCPW=new ClinicalPathWay();
			//objCPW.Rowid = arrItems[0];
			//objCPW.MRADMDR = arrItems[1];
			objCPW.CPWDR = arrItems[0];
			objCPW.CPWDesc = arrItems[2];
			objCPW.IsOffShoot = arrItems[18];
			return objCPW;
		}
		return null;
	}
		
	function GetClinPathWay(argPathWayID){
		var objMRClinicalPathWays = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinicalPathWays");
		var ret = objMRClinicalPathWays.GetStringById(argPathWayID,CHR_1);
		if (ret!=""){
			var arrItems=ret.split(CHR_1);
			var objCPW=new ClinicalPathWay();
			objCPW.Rowid = arrItems[0];
			objCPW.MRADMDR = arrItems[1];
			objCPW.CPWDR = arrItems[2];
			objCPW.CPWDesc = arrItems[3];
			objCPW.CPWEpDR = arrItems[4];
			objCPW.CPWEpDesc = arrItems[5];
			objCPW.CPWEpStepDR = arrItems[6];
			objCPW.CPWEPStepDesc = arrItems[7];
			objCPW.Status = arrItems[8];
			objCPW.StatusDesc = arrItems[9];
			objCPW.InDoctorDR = arrItems[10];
			objCPW.InDoctorDesc = arrItems[11];
			objCPW.InDate = arrItems[12];
			objCPW.InTime = arrItems[13];
			objCPW.OutDoctorDR = arrItems[14];
			objCPW.OutDoctorDesc = arrItems[15];
			objCPW.OutDate = arrItems[16];
			objCPW.OutTime = arrItems[17];
			objCPW.OutReasonDR = arrItems[18];
			objCPW.OutReasonDesc = arrItems[19];
			objCPW.UpdateUserDR = arrItems[20];
			objCPW.UpdateUserDesc = arrItems[21];
			objCPW.UpdateDate = arrItems[22];
			objCPW.UpdateTime = arrItems[23];
			objCPW.Comments = arrItems[24];
			return objCPW;
		}
		return null;
	}
	
	function GetCurrentStep(EpisodeID){
		var service = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinicalPathWays");
		var ret = service.GetCurrentStepInfo(EpisodeID,CHR_1)
		if (ret!=""){
			var arrItems=ret.split(CHR_1);
			var objCPW=new CPWStep();
			objCPW.admDateNo = arrItems[0];
			objCPW.cpwDateNo = arrItems[1];
			objCPW.currentStepId = arrItems[2];
			objCPW.currentStepDesc = arrItems[3];
			objCPW.currentStepDayNo = arrItems[4];
			return objCPW;
		}
		return null
	}
	
	function GetItemACRIM(ItemId){
		var service = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysSrv");
		var ret=service.GetItemDetailsById(ItemId);
		var itemArray = [];	
		if (ret=="") return itemArray;
		var arrItems=ret.split(CHR_1);
		for (var i=0;i<arrItems.length;i++){
			var itemarcim=arrItems[i];
			if (itemarcim!=""){
				var arcims=itemarcim.split("^");
				var objTMP = new Object();
				objTMP.Index = arcims[0];
				objTMP.arcim = arcims[1];
				objTMP.arcimDesc = arcims[2];
				objTMP.defaults = arcims[3];
				objTMP.itmLinkNo = arcims[4];
				objTMP.isOptional = arcims[5];
				itemArray.push(objTMP);
			}
		}
		return itemArray;
	}
	
	function GetImplements(PathWayID,ItemId){
		var service = ExtTool.StaticServerObject("web.DHCCPW.MR.Implement");
		var ret=service.GetImplements(PathWayID,ItemId);
		var itemArray = [];
		if (ret=="") return itemArray;
		var arrItems=ret.split(CHR_1);
		for (var i=0;i<arrItems.length;i++){
			var itemimpl=arrItems[i];
			if (itemimpl!=""){
				var impls=itemimpl.split("^");
				var objTMP = new Object();
				objTMP.ImplID = impls[0];
				objTMP.ImplDesc = impls[1];
				itemArray.push(objTMP);
			}
		}
		return itemArray;
	}
	
	function DHCPaPerson(){
		var objTMP = new Object();
		objTMP.PatientID = "";
		objTMP.PapmiNo = "";
		objTMP.PatName = "";
		objTMP.PatSex = "";
		objTMP.BirthDay = "";
		objTMP.Age = "";
		return objTMP;
	}
	
	function DHCPAADM(){
		var objTMP = new Object();
		objTMP.EpisodeID = "";
		objTMP.AdmType = "";
		objTMP.AdmDate = "";
		objTMP.AdmTime = "";
		objTMP.AdmDoc = "";
		objTMP.AdmLoc = "";
		objTMP.AdmWard ="";
		objTMP.AdmRoom ="";
		objTMP.AdmBed ="";
		objTMP.AdmStatus = "";
		objTMP.DischDate = "";
		objTMP.DischTime = "";
		objTMP.MRAdm = "";
		objTMP.PatientID = "";
		return objTMP;
	}
	
	function ClinicalPathWay(){
		var objTMP = new Object();
		objTMP.Rowid = "";
		objTMP.MRADMDR = "";
		objTMP.CPWDR = "";
		objTMP.CPWDesc = "";
		objTMP.CPWEpDR = "";
		objTMP.CPWEpDesc = "";
		objTMP.CPWEpStepDR ="";
		objTMP.CPWEPStepDesc ="";
		objTMP.Status ="";
		objTMP.StatusDesc ="";
		objTMP.InDoctorDR ="";
		objTMP.InDoctorDesc ="";
		objTMP.InDate ="";
		objTMP.InTime ="";
		objTMP.OutDoctorDR ="";
		objTMP.OutDoctorDesc ="";
		objTMP.OutDate ="";
		objTMP.OutTime ="";
		objTMP.OutReasonDR ="";
		objTMP.OutReasonDesc ="";
		objTMP.UpdateUserDR ="";
		objTMP.UpdateUserDesc ="";
		objTMP.UpdateDate ="";
		objTMP.UpdateTime ="";
		objTMP.Comments ="";
		objTMP.IsOffShoot ="";
		return objTMP;
	}
	
	function CPWStep(){
		var objTMP = new Object();
		objTMP.admDateNo = "";
		objTMP.cpwDateNo = "";
		objTMP.currentStepId = "";
		objTMP.currentStepDesc = "";
		objTMP.currentStepDayNo = "";
		return objTMP;
	}
	
	function ItemACRIM(){		
		var objTMP = new Object();
		objTMP.Index = "";
		objTMP.arcim = "";
		objTMP.arcimDesc = "";
		objTMP.defaults = "";
		return objTMP;
	}
	return obj;
}

/******************************************************************************
/writer: zhufei
/date  : 2010-12-22
/for   : 表单展现
/input : 表单权限控制(0-没权限,1-执行权限,2-撤销权限)
/        PathWayID       : 实施路径ID
/        OEOrderFlag     : 医嘱标记        0/1
/        NEOrderFlag     : 护嘱标记        0/1
/        OEOutOrderFlag  : 门诊医嘱标记    0/1/2
/        NEOutOrderFlag  : 门诊护嘱标记    0/1/2
/        ConsultFlag     : 诊疗标记        0/1/2
/        NurseFlag       : 护理标记        0/1/2
*******************************************************************************/
function FormShowHeader(PathWayID,OEOrderFlag,NEOrderFlag,OEOutOrderFlag,NEOutOrderFlag,ConsultFlag,NurseFlag,VarianceFlag){
	var objFormShowNew = new FormShowNew(PathWayID,OEOrderFlag,NEOrderFlag,OEOutOrderFlag,NEOutOrderFlag,ConsultFlag,NurseFlag,VarianceFlag);
	objFormShowNew.FromShowWindow.show();
	ExtDeignerHelper.HandleResize(objFormShowNew);
}

function FormShowNew(PathWayID,OEOrderFlag,NEOrderFlag,OEOutOrderFlag,NEOutOrderFlag,ConsultFlag,NurseFlag,VarianceFlag){
	if (!PathWayID) return;
	var obj = new Object();
	obj.FromShowPanel = new Ext.Panel({
		id : 'FromShowPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,frame : true
		,layout : 'fit'
	})
	obj.FromShowWindow = new Ext.Window({
		id : 'FromShowWindow'
		,collapsed : true
		,buttonAlign : 'center'
		,maximized : true
		,resizable : false
		,title : '临床路径表单'
		,layout : 'border'
		,items:[
			obj.FromShowPanel
		]
	});
	window.returnValue="";
	var ShowCallBack = function(value){
		window.returnValue = value;
		window.close();
	}
	var ret=FormShow(obj.FromShowPanel,ShowCallBack,0,"",PathWayID,OEOrderFlag,NEOrderFlag,OEOutOrderFlag,NEOutOrderFlag,ConsultFlag,NurseFlag,VarianceFlag)
	if (!ret) {
		//ExtTool.alert("提示","该患者尚未入径!");
		window.close();
	}
	return obj;
}

function CPWFormShowHeader(CPWID){
	var objFormShowNew = new CPWFormShowNew(CPWID);
	objFormShowNew.FromShowWindow.show();
	ExtDeignerHelper.HandleResize(objFormShowNew);
	
	//removed btn by wuqk 2011-12-27
	//Ext.getCmp("btnCloseForm").setVisible(true);
}

function CPWFormShowNew(CPWID){
	if (!CPWID) return;
	var obj = new Object();
	obj.FromShowPanel = new Ext.Panel({
		id : 'FromShowPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,frame : true
		,layout : 'fit'
	})
	obj.FromShowWindow = new Ext.Window({
		id : 'FromShowWindow'
		,collapsed : true
		,closable : false
		,buttonAlign : 'center'
		,maximized : true
		,resizable : false
		//,title : '临床路径表单'
		,layout : 'border'
		,items:[
			obj.FromShowPanel
		]
	});
	window.returnValue="";
	var ShowCallBack = function(value){
		window.returnValue = value;
		window.close();
	}
	
	var ret=FormShow(obj.FromShowPanel,ShowCallBack,0,CPWID,0,0,0,0,0,0,0,0)
	if (!ret) {
		//ExtTool.alert("提示","该患者尚未入径!");
		window.close();
	}
	return obj;
}

//************************************Start***********************************
//add by zf 20120313
//出入径页面,弹出表单展现页面
function CPWFormShowHeaderNew(CPWID){
	
	var objFormShowNew = new CPWFormShowNew111(CPWID);
	objFormShowNew.FromShowWindow.show();
	
	ExtDeignerHelper.HandleResize(objFormShowNew);
}

function CPWFormShowNew111(CPWID){
	if (!CPWID) return;
	var obj = new Object();
	obj.FromShowPanel = new Ext.Panel({
		id : 'FromShowPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,frame : true
		,layout : 'fit'
	})
	obj.FromShowWindow = new Ext.Window({
		id : 'FromShowWindow'
		//,collapsed : true
		,closable : true
		,buttonAlign : 'center'
		,maximized : true
		,resizable : false
		,title : '临床路径表单展现'
		,layout : 'border'
		,items:[
			obj.FromShowPanel
		]
	});
	window.returnValue="";
	var ShowCallBack = function(value){
		window.returnValue = value;
		window.close();
	}
	
	var ret=FormShow(obj.FromShowPanel,ShowCallBack,0,CPWID,0,0,0,0,0,0,0,0)
	if (!ret) {
		//ExtTool.alert("提示","该患者尚未入径!");
		window.close();
	}
	return obj;
}
//*************************************End************************************


function PrintPathWayForm(PathWayID){
	if (!PathWayID) {
		ExtTool.alert("提示","请选择一个出入径记录再打印!");
		return;
	}
	var PrintType = ExtTool.RunServerMethod("web.DHCCPW.MRC.BaseConfig","GetValueByCode","CPWImplFormPrintType");
	if (PrintType=='Y') {
		PrintPathWayFormY(PathWayID);
	}
	else{
		PrintPathWayFormX(PathWayID);
	}
}

function PrintPathWayFormX(PathWayID){
	var PrintPath="";
	if (!PathWayID) {
		ExtTool.alert("提示","请选择一个出入径记录再打印!");
		return;
	}
	/*
	// update by zf 2012-07-18
	var objMRClinPathWaysResult = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysResult");
	if (objMRClinPathWaysResult){
		var flg=objMRClinPathWaysResult.IsSaveResult(PathWayID);
		if (flg!='1') {
			ExtTool.alert("提示","请填写疗效评估记录再打印!");
			return;
		}
	}
	*/
	var objServer = ExtTool.StaticServerObject("web.DHCCPW.MR.SysBaseSrv");
	if (objServer){
		var serverInfo = objServer.GetServerInfo();
		if (serverInfo) {
			var tmpList = serverInfo.split(CHR_1);
			if (tmpList.length>=7){
				PrintPath = tmpList[4];
			}
		}
	}
	if ((!PathWayID)||(!PrintPath)) return;
	
	var filePath = PrintPath + "\\DHCCPWImplForm.xls";
	
	var title1="",title2="",title3="",title4="";
	var objImplementPrint=ExtTool.StaticServerObject("web.DHCCPW.MR.ImplementPrint");
	var arrSheetList;
	Ext.dhcc.DataToExcelTool.ExcelApp.InitApp();
	var flg=Ext.dhcc.DataToExcelTool.ExcelApp.AddBook(filePath);
	if (flg) {
		arrSheetList=Ext.dhcc.DataToExcelTool.ExcelApp.GetSheetNames();
		if (arrSheetList){
			for (var i=0;i<arrSheetList.length;i++){
				if (arrSheetList[i]=="通用模板"){
					Ext.dhcc.DataToExcelTool.ExcelApp.GetSheet("通用模板");
					
					title1=objImplementPrint.GetTitleInfo(PathWayID,1);
					title2=objImplementPrint.GetTitleInfo(PathWayID,2);
					title3=objImplementPrint.GetTitleInfo(PathWayID,3);
					title4=objImplementPrint.GetTitleInfo(PathWayID,4);
					
					if ((title1)&&(title2)&&(title3)&&(title4)) {
						//表头(名称+准入提示+病人信息+就诊信息)
						
						Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(1,1,title1);
						var title2ls=title2.split(CHR_1);
						Ext.dhcc.DataToExcelTool.ExcelApp.SetCellsRowHeigthByRow(2,15*title2ls[0]);
						Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(2,1,title2ls[1]);
						Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(3,1,title3);
						Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(4,1,title4);
						
						var row=6,rowStep=0,col=1,len=10;
						var epSteps=objImplementPrint.GetEpSteps(PathWayID);
						if (epSteps){
							var tmpEpStepList=epSteps.split(CHR_1);
							for (var stepInd=0;stepInd<tmpEpStepList.length;stepInd++){
								var epStep=tmpEpStepList[stepInd];
								var tmpEpStepSub=epStep.split(CHR_2);
								if (tmpEpStepSub.length>=2){
									var epStepID=tmpEpStepSub[0];
									var epStepDesc=tmpEpStepSub[1];
									var epStepSign=tmpEpStepSub[2];
									
									//阶段+步骤
									Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,1,epStepDesc);
									Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(row,1,row,4);
									Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeHorizontalAlignment(row,1,row,1,3);
									row++;
									
									//签名信息
									Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,1,epStepSign);
									Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(row,1,row,4);
									Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeHorizontalAlignment(row,1,row,1,3);
									row++;
									
									//项目明细(主要诊疗工作)
									rowStep=0
									col=1,len=23;
									var tmpItems=objImplementPrint.GetEpStepItems(PathWayID,epStepID,col,len);
									var tmpItemList=tmpItems.split(CHR_1);
									if (tmpItemList.length>rowStep){
										rowStep=tmpItemList.length;
									}
									for (var itemInd=0;itemInd<tmpItemList.length;itemInd++){
										Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row+itemInd,col,tmpItemList[itemInd]);
									}
									
									//项目明细(重要医嘱)
									col=2,len=36;
									var tmpItems=objImplementPrint.GetEpStepItems(PathWayID,epStepID,col,len);
									var tmpItemList=tmpItems.split(CHR_1);
									if (tmpItemList.length>rowStep){
										rowStep=tmpItemList.length;
									}
									for (var itemInd=0;itemInd<tmpItemList.length;itemInd++){
										Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row+itemInd,col,tmpItemList[itemInd]);
									}
									
									//项目明细(主要护理工作)
									col=3,len=24;
									var tmpItems=objImplementPrint.GetEpStepItems(PathWayID,epStepID,col,len);
									var tmpItemList=tmpItems.split(CHR_1);
									if (tmpItemList.length>rowStep){
										rowStep=tmpItemList.length;
									}
									for (var itemInd=0;itemInd<tmpItemList.length;itemInd++){
										Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row+itemInd,col,tmpItemList[itemInd]);
									}
									
									//项目明细(病情变化)
									col=4,len=17;
									var tmpItems=objImplementPrint.GetEpStepItems(PathWayID,epStepID,col,len);
									var tmpItemList=tmpItems.split(CHR_1);
									if (tmpItemList.length>rowStep){
										rowStep=tmpItemList.length;
									}
									for (var itemInd=0;itemInd<tmpItemList.length;itemInd++){
										Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row+itemInd,col,tmpItemList[itemInd]);
									}
									
									//设置下一步骤起始行
									row=row+rowStep;
								}
							}
						}
						//直接保存
						//Ext.dhcc.DataToExcelTool.ExcelApp.SaveBook(title1);
						//直接打印
						//Ext.dhcc.DataToExcelTool.ExcelApp.PrintOut();
						//打印预览
						Ext.dhcc.DataToExcelTool.ExcelApp.SetVisible(true);
						Ext.dhcc.DataToExcelTool.ExcelApp.PrintOut(true);
					}
				}
			}
		}
	}
	//直接保存+直接打印 Close
    //Ext.dhcc.DataToExcelTool.ExcelApp.Close();
    //打印预览 Close
    Ext.dhcc.DataToExcelTool.ExcelApp.Close(true);
}

function PrintPathWayFormY(PathWayID){
	var PrintPath="";
	
	//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	//组织临床路径表单数据
	//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	//取路径基本信息
	var BaseInfo = ExtTool.RunServerMethod("DHCCPW.MR.FORM.ImplPrintSrv","GetPathWayBaseInfo",PathWayID);
	if (!BaseInfo) return false;
	//组织路径基本信息
	var arrBaseInfo = BaseInfo.split("^");
	var objForm = new Object();
	objForm.PathWayDesc  = arrBaseInfo[0] //"肺血栓栓塞症（中低危）临床路径表单";
	objForm.ApplyObject  = arrBaseInfo[1] //"第一诊断为肺血栓栓塞症（ICD-10：I26.001/I26.901）"
	objForm.PatientInfo1 = arrBaseInfo[2] //"患者姓名：           性别：    年龄：    门诊号：       住院号：      "
	objForm.PatientInfo2 = arrBaseInfo[3] //"住院日期：    年  月  日  出院日期：    年  月   日   标准住院日：7-10天"
	objForm.PageCount    = 0;
	objForm.StepList     = new Array();
	objForm.PageRows     = new Array();
	
	//取路径步骤信息
	var StepList = ExtTool.RunServerMethod("DHCCPW.MR.FORM.ImplPrintSrv","GetPathWayStepList",PathWayID);
	if (!StepList) return false;
	//组织路径步骤信息
	var arrStepList = StepList.split(CHR_1);
	for (var SInd = 0; SInd < arrStepList.length; SInd++){
		var tStepInfo = arrStepList[SInd];
		if (!tStepInfo) continue;
		var arrStepInfo = tStepInfo.split("^");
		
		var objStep = new Object();
		objStep.PageIndex    = arrStepInfo[0];
		objStep.PageStepCnt  = arrStepInfo[1];
		objStep.StepIndex    = arrStepInfo[2];
		objStep.StepNumber   = arrStepInfo[3];
		objStep.StepID       = arrStepInfo[4];
		objStep.StepDesc     = arrStepInfo[5];
		objStep.StepDate     = arrStepInfo[6];
		objStep.StepDocSign  = arrStepInfo[7];
		objStep.StepNurSign  = arrStepInfo[8];
		objStep.ItmCatList  = new Array();
		
		var objItmCat = new Object();
		objItmCat.ItmCatIndex = '01';
		objItmCat.ItmCatDesc = '主要诊疗工作';
		objItmCat.SubCatList = new Array();
		objStep.ItmCatList[objItmCat.ItmCatIndex] = objItmCat;
		
		var objItmCat = new Object();
		objItmCat.ItmCatIndex = '02';
		objItmCat.ItmCatDesc = '重点医嘱';
		objItmCat.SubCatList = new Array();
		objStep.ItmCatList[objItmCat.ItmCatIndex] = objItmCat;
		
		var objItmCat = new Object();
		objItmCat.ItmCatIndex = '03';
		objItmCat.ItmCatDesc = '主要护理工作';
		objItmCat.SubCatList = new Array();
		objStep.ItmCatList[objItmCat.ItmCatIndex] = objItmCat;
		
		var objItmCat = new Object();
		objItmCat.ItmCatIndex = '04';
		objItmCat.ItmCatDesc = '病情变异记录';
		objItmCat.SubCatList = new Array();
		objStep.ItmCatList[objItmCat.ItmCatIndex] = objItmCat;
		
		objForm.StepList[objStep.StepNumber] = objStep;
		
		objForm.PageRows[objStep.PageIndex + '-01'] = 3;
		objForm.PageRows[objStep.PageIndex + '-02'] = 3;
		objForm.PageRows[objStep.PageIndex + '-03'] = 3;
		objForm.PageRows[objStep.PageIndex + '-04'] = 3;
		
		if (objStep.PageIndex>objForm.PageCount) objForm.PageCount = objStep.PageIndex;
	}
	
	//取路径项目信息
	var conn = Ext.lib.Ajax.getConnectionObject().conn;
	var url = ExtToolSetting.RunQueryPageURL + '?1=1'
	url += '&ClassName=' + 'DHCCPW.MR.FORM.ImplPrintSrv'
	url += '&QueryName=' + 'QryFormImplRst'
	url += '&Arg1=' + PathWayID
	url += '&ArgCnt=' + 1
	url += '&2=2'
	conn.open('post',url,false);
	conn.send(null);
	if (conn.status != '200') {
		ExtTool.alert('错误', '查询Query报错!');
		return false;
	}
	var jsonData = new Ext.decode(conn.responseText);
	if (jsonData.total < 1){
		alert('Query输出结果错误!DHCCPW.MR.FORM.ImplPrintSrv:QryFormImplRst');
		return false;
	}
	//组织路径项目信息
	for (var row = 0; row < jsonData.record.length; row++){
		var record = jsonData.record[row];
		if (!record) continue;
		
		var StepCINumber   = record.StepCINumber
		var StepNumber     = record.StepNumber
		var PageIndex      = record.PageIndex
		var ItmCatIndex    = record.ItmCatIndex
		var SubCatIndex    = record.SubCatIndex
		var SubCatDesc     = record.SubCatDesc
		var ItemDesc       = record.ItemDesc   //加上?或□
		
		if (!objForm.StepList[StepNumber]) continue;
		var objStep = objForm.StepList[StepNumber];
		if (!objStep.ItmCatList[ItmCatIndex]) continue;
		var objItmCat = objStep.ItmCatList[ItmCatIndex];
		
		if (objItmCat.SubCatList[SubCatIndex]){
			var objSubCat = objItmCat.SubCatList[SubCatIndex];
		} else {
			var objSubCat = new Object();
			objSubCat.SubCatIndex = SubCatIndex;
			objSubCat.SubCatDesc = SubCatDesc;
			objSubCat.ItemList = new Array();
		}
		objSubCat.ItemList.push(record);
		objItmCat.SubCatList[SubCatIndex] = objSubCat;
		objStep.ItmCatList[ItmCatIndex] = objItmCat;
		objForm.StepList[StepNumber] = objStep;
		
		var PageRows = objForm.PageRows[PageIndex + '-' + ItmCatIndex];
		if (StepCINumber>PageRows){
			objForm.PageRows[PageIndex + '-' + ItmCatIndex] = StepCINumber;
		}
	}
	//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	//组织临床路径表单数据
	//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	
	var objServer = ExtTool.StaticServerObject("web.DHCCPW.MR.SysBaseSrv");
	if (objServer){
		var serverInfo = objServer.GetServerInfo();
		if (serverInfo) {
			var tmpList = serverInfo.split(CHR_1);
			if (tmpList.length>=7){
				PrintPath = tmpList[4];
			}
		}
	}
	if ((!PathWayID)||(!PrintPath)) return;
	
	var filePath = PrintPath + "\\DHCCPWImplFormNew.xls";
	
	Ext.dhcc.DataToExcelTool.ExcelApp.InitApp();
	Ext.dhcc.DataToExcelTool.ExcelApp.SetVisible(true);
	var flg=Ext.dhcc.DataToExcelTool.ExcelApp.AddBook(filePath);
	if (flg) {
		Ext.dhcc.DataToExcelTool.ExcelApp.GetSheet("竖打模板");
	} else {
		Ext.dhcc.DataToExcelTool.ExcelApp.Close();
		return;
	}
	
	var objCurrPage = new Object();
	objCurrPage.ColMin = 2;       //表单第1步骤初始列
	objCurrPage.ColMax = 92;      //表单最大列
	objCurrPage.FPRows = 48;      //表单首页行数
	objCurrPage.OPRows = 50;      //表单其他页行数
	
	objCurrPage.RowNode0 = 0;     //表单步骤初始行
	objCurrPage.RowNode1 = 0;     //主要诊疗工作最大行
	objCurrPage.RowNode2 = 0;     //重点医嘱最大行
	objCurrPage.RowNode3 = 0;     //主要护理工作最大行
	objCurrPage.RowNode4 = 0;     //病情变异记录最大行
	
	for (var IndP = 1; IndP <= objForm.PageCount; IndP++){
		for (var IndS = 1; IndS < objForm.StepList.length; IndS++){
			var objStep = objForm.StepList[IndS];
			if (objStep.PageIndex != IndP) continue;
			
			//当前步骤最小列及最大列初始化
			var colMin = 0, colMax = 0;
			var colWidth = parseInt((objCurrPage.ColMax-objCurrPage.ColMin+1)/objStep.PageStepCnt);
			if (objStep.PageStepCnt == 3){
				if (objStep.StepIndex == 1) colMin = objCurrPage.ColMin, colMax = colMin + colWidth - 1;
				if (objStep.StepIndex == 2) colMin = objCurrPage.ColMin + colWidth*1, colMax = colMin + colWidth - 1;
				if (objStep.StepIndex == 3) colMin = objCurrPage.ColMin + colWidth*2, colMax = objCurrPage.ColMax;
			} else if (objStep.PageStepCnt == 2){
				if (objStep.StepIndex == 1) colMin = objCurrPage.ColMin, colMax = colMin + colWidth - 1;
				if (objStep.StepIndex == 2) colMin = objCurrPage.ColMin + colWidth*1, colMax = objCurrPage.ColMax;
			} else {
				colMin = objCurrPage.ColMin, colMax = objCurrPage.ColMax;
			}
			
			var row = 0;
			if (objStep.PageIndex == 1){
				if (objStep.StepIndex == 1) {
					var colMin0 = 1;
					var colMax0 = objCurrPage.ColMax;
					
					row++;
					//输出路径名称
					Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,colMin0,objForm.PathWayDesc);
					
					row++;
					//输出"适用对象"
					Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,colMin0,objForm.ApplyObject);
					
					row++;
					//输出"病人基本信息1"
					Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,colMin0,objForm.PatientInfo1);
					
					row++;
					//输出"病人基本信息1"
					Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,colMin0,objForm.PatientInfo2);
					
					objCurrPage.RowNode0 = row;
				} else {
					row = objCurrPage.RowNode0;
				}
			} else {
				if (objStep.StepIndex == 1) {
					row = objCurrPage.RowNode0;
					var tFPRows = objCurrPage.FPRows;
					var tOPRows = objCurrPage.OPRows;
					row = ((parseInt((row-tFPRows)/tOPRows)+1)*tOPRows)+tFPRows;
					objCurrPage.RowNode0 = row;
				} else {
					row = objCurrPage.RowNode0;
				}
			}
			objCurrPage.RowNode1 = objCurrPage.RowNode0 + objForm.PageRows[objStep.PageIndex + '-01'] + 2;
			objCurrPage.RowNode2 = objCurrPage.RowNode1 + objForm.PageRows[objStep.PageIndex + '-02'];
			objCurrPage.RowNode3 = objCurrPage.RowNode2 + objForm.PageRows[objStep.PageIndex + '-03'];
			objCurrPage.RowNode4 = objCurrPage.RowNode3 + objForm.PageRows[objStep.PageIndex + '-04'];
			
			row++;
			//输出表单步骤名称
			Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,colMin,objStep.StepDesc);
			Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(row,colMin,row,colMax);  //合并单元格
			Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeHorizontalAlignment(row,colMin,row,colMin,3);  //单元格居左|中|右
			
			row++;
			//输出表单步骤时间
			Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,colMin,objStep.StepDate);
			Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(row,colMin,row,colMax);  //合并单元格
			Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeHorizontalAlignment(row,colMin,row,colMin,3);  //单元格居左|中|右
			
			var CatList = '01^02^03^04';
			var arrCatList = CatList.split('^');
			for (var indC = 0; indC < arrCatList.length; indC++){
				var CatIndex = arrCatList[indC];
				if (!CatIndex) continue;
				
				if (CatIndex == '01') row = objCurrPage.RowNode0 + 2, rowMax = objCurrPage.RowNode1;
				if (CatIndex == '02') row = objCurrPage.RowNode1, rowMax = objCurrPage.RowNode2;
				if (CatIndex == '03') row = objCurrPage.RowNode2, rowMax = objCurrPage.RowNode3;
				if (CatIndex == '04') row = objCurrPage.RowNode3, rowMax = objCurrPage.RowNode4;
				
				//输出"主要诊疗工作"、"重点医嘱"、"主要护理工作"、"病情变异记录"
				var objItmCatList = objStep.ItmCatList[CatIndex];
				var arrSubCatList = objItmCatList.SubCatList;
				for (var indSC = 0; indSC < arrSubCatList.length; indSC++){
					var objSC = arrSubCatList[indSC];
					if (!objSC) continue;
					
					if ((arrSubCatList.length>2)||(CatIndex == '02')){
						row++;
						//输出"***-分类"
						Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,colMin,objSC.SubCatDesc);
						Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(row,colMin,row,colMax);  //合并单元格
						Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeHorizontalAlignment(row,colMin,row,colMin,1);  //单元格居左|中|右
						Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeFontBold(row,colMin,row,colMin,1);  //单元格加粗
					}
					
					for (var indSCI = 0; indSCI < objSC.ItemList.length; indSCI++){
						var objSCI = objSC.ItemList[indSCI];
						if (!objSCI) continue;
						
						row++;
						//输出"***-项目"
						Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,colMin,objSCI.ItemDesc);
						Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(row,colMin,row,colMax);  //合并单元格
						Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeHorizontalAlignment(row,colMin,row,colMin,1);  //单元格居左|中|右
					}
				}
				while (row<rowMax){
					row++;
					Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(row,colMin,row,colMax);  //合并单元格
				}
			}
			
			row = objCurrPage.RowNode4;
			
			row++;
			//输出"护士签名"
			Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,colMin,objStep.StepNurSign);
			Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(row,colMin,row+1,colMax);  //合并单元格
			Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeHorizontalAlignment(row,colMin,row+1,colMin,3);  //单元格居左|中|右
			row++;
			
			row++;
			//输出"医师签名"
			Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,colMin,objStep.StepDocSign);
			Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(row,colMin,row+1,colMax);  //合并单元格
			Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeHorizontalAlignment(row,colMin,row+1,colMin,3);  //单元格居左|中|右
			row++;
			
			//设置边框
			var tRow = objCurrPage.RowNode0 + 1;
			//输出表头“步骤”
			Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyle(tRow,colMin,tRow,colMax,1);  //单元格边框 实线
			tRow = tRow + 1;
			//输出表头“时间”
			Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyle(tRow,colMin,tRow,colMax,1);  //单元格边框 实线
			tRow = tRow + 1;
			//输出表头"主要诊疗工作"
			Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyleNew(tRow,colMin,objCurrPage.RowNode1,colMax,1,1);  //单元格边框 实线
			Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyleNew(tRow,colMin,objCurrPage.RowNode1,colMax,2,1);  //单元格边框 实线
			Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyleNew(tRow,colMin,tRow,colMax,3,1);  //单元格边框 实线
			tRow = objCurrPage.RowNode1 + 1;
			//输出表头"重点医嘱"
			Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyleNew(tRow,colMin,objCurrPage.RowNode2,colMax,1,1);  //单元格边框 实线
			Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyleNew(tRow,colMin,objCurrPage.RowNode2,colMax,2,1);  //单元格边框 实线
			Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyleNew(tRow,colMin,tRow,colMax,3,1);  //单元格边框 实线
			tRow = objCurrPage.RowNode2 + 1;
			//输出表头"主要护理工作"
			Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyleNew(tRow,colMin,objCurrPage.RowNode3,colMax,1,1);  //单元格边框 实线
			Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyleNew(tRow,colMin,objCurrPage.RowNode3,colMax,2,1);  //单元格边框 实线
			Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyleNew(tRow,colMin,tRow,colMax,3,1);  //单元格边框 实线
			tRow = objCurrPage.RowNode3 + 1;
			//输出表头"病情变异记录"
			Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyleNew(tRow,colMin,objCurrPage.RowNode4,colMax,1,1);  //单元格边框 实线
			Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyleNew(tRow,colMin,objCurrPage.RowNode4,colMax,2,1);  //单元格边框 实线
			Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyleNew(tRow,colMin,tRow,colMax,3,1);  //单元格边框 实线
			tRow = objCurrPage.RowNode4 + 1;
			//输出表头"护士签名"
			Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyle(tRow,colMin,tRow + 1,colMax,1);  //单元格边框 实线
			tRow = tRow + 2;
			//输出表头"医师签名"
			Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyle(tRow,colMin,tRow + 1,colMax,1);  //单元格边框 实线
			
			//设置左列头
			if (objStep.StepIndex == objStep.PageStepCnt){
				var colMin0 = 1;
				var colMax0 = objCurrPage.ColMin - 1;
				var tRow = objCurrPage.RowNode0 + 1;
				//输出表头“步骤”
				Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(tRow,colMin0,'步骤');
				Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(tRow,colMin0,tRow,colMax0);  //合并单元格
				Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeHorizontalAlignment(tRow,colMin0,tRow,colMax0,3);  //单元格居左|中|右
				Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyle(tRow,colMin0,tRow,colMax0,1);  //单元格边框 实线
				tRow = tRow + 1;
				//输出表头“时间”
				Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(tRow,colMin0,'时间');
				Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(tRow,colMin0,tRow,colMax0);  //合并单元格
				Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeHorizontalAlignment(tRow,colMin0,tRow,colMax0,3);  //单元格居左|中|右
				Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyle(tRow,colMin0,tRow,colMax0,1);  //单元格边框 实线
				tRow = tRow + 1;
				//输出表头"主要诊疗工作"
				Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(tRow,colMin0,'主要诊疗工作');
				Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(tRow,colMin0,objCurrPage.RowNode1,colMax0);  //合并单元格
				Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeHorizontalAlignment(tRow,colMin0,objCurrPage.RowNode1,colMax0,3);  //单元格居左|中|右
				Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyle(tRow,colMin0,objCurrPage.RowNode1,colMax0,1);  //单元格边框 实线
				tRow = objCurrPage.RowNode1 + 1;
				//输出表头"重点医嘱"
				Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(tRow,colMin0,'重点医嘱');
				Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(tRow,colMin0,objCurrPage.RowNode2,colMax0);  //合并单元格
				Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeHorizontalAlignment(tRow,colMin0,objCurrPage.RowNode2,colMax0,3);  //单元格居左|中|右
				Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyle(tRow,colMin0,objCurrPage.RowNode2,colMax0,1);  //单元格边框 实线
				tRow = objCurrPage.RowNode2 + 1;
				//输出表头"主要护理工作"
				Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(tRow,colMin0,'主要护理工作');
				Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(tRow,colMin0,objCurrPage.RowNode3,colMax0);  //合并单元格
				Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeHorizontalAlignment(tRow,colMin0,objCurrPage.RowNode3,colMax0,3);  //单元格居左|中|右
				Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyle(tRow,colMin0,objCurrPage.RowNode3,colMax0,1);  //单元格边框 实线
				tRow = objCurrPage.RowNode3 + 1;
				//输出表头"病情变异记录"
				Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(tRow,colMin0,'病情变异记录');
				Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(tRow,colMin0,objCurrPage.RowNode4,colMax0);  //合并单元格
				Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeHorizontalAlignment(tRow,colMin0,objCurrPage.RowNode4,colMax0,3);  //单元格居左|中|右
				Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyle(tRow,colMin0,objCurrPage.RowNode4,colMax0,1);  //单元格边框 实线
				tRow = objCurrPage.RowNode4 + 1;
				//输出表头"护士签名"
				Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(tRow,colMin0,'护士签名');
				Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(tRow,colMin0,tRow + 1,colMax0);  //合并单元格
				Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeHorizontalAlignment(tRow,colMin0,tRow + 1,colMax0,3);  //单元格居左|中|右
				Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyle(tRow,colMin0,tRow + 1,colMax0,1);  //单元格边框 实线
				tRow = tRow + 2;
				//输出表头"医师签名"
				Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(tRow,colMin0,'医师签名');
				Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(tRow,colMin0,tRow + 1,colMax0);  //合并单元格
				Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeHorizontalAlignment(tRow,colMin0,tRow + 1,colMax0,3);  //单元格居左|中|右
				Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeBordersLineStyle(tRow,colMin0,tRow + 1,colMax0,1);  //单元格边框 实线
			}
		}
	}
	
	//直接保存
	//Ext.dhcc.DataToExcelTool.ExcelApp.SaveBook(title1);
	//直接打印
	//Ext.dhcc.DataToExcelTool.ExcelApp.PrintOut();
	//打印预览
	Ext.dhcc.DataToExcelTool.ExcelApp.SetVisible(true);
	Ext.dhcc.DataToExcelTool.ExcelApp.PrintOut(true);
	
	//直接保存+直接打印 Close
	//Ext.dhcc.DataToExcelTool.ExcelApp.Close();
	//打印预览 Close
	Ext.dhcc.DataToExcelTool.ExcelApp.Close(true);
	return;
}

function PrintPathWayFormToPatient(objCPW,objPerson,objPaadm)
{
	if ((!objCPW)||(!objPerson)||(!objPaadm)) return;
	var PathWayName=objCPW.CPWDesc;
	if (!PathWayName) return;
	
	var objServer = ExtTool.StaticServerObject("web.DHCCPW.MR.SysBaseSrv");
	if (objServer){
		var serverInfo = objServer.GetServerInfo();
		if (serverInfo) {
			var tmpList = serverInfo.split(CHR_1);
			if (tmpList.length>=7){
				PrintPath = tmpList[4];
			}
		}
	}
	if (!PrintPath) return;
	
	var wordApp = null;
	try{
		wordApp = new ActiveXObject('Word.Application');
	}catch(e){
		alert(e.name + ": " + e.message +',不能创建Word对象或者客户端没有安装Word软件!');
		return;
	}
	
	//同名 患者版表单打印
	var filePath = PrintPath + "DHCCPWFormToPatient\\" + PathWayName +".dot";
	if (IsExistsFile(filePath))
	{
		try {
			var wordDoc = wordApp.Documents.Open(filePath);
			//wordApp.Application.Visible = false;
			wordApp.Visible = true;
			
			if (objCPW.CPWDesc=='') objCPW.CPWDesc='            '
			WordApp_ReplaceText(wordApp,'<路径名称>',objCPW.CPWDesc);
			if (objPerson.PatName=='') objPerson.PatName='        '
			WordApp_ReplaceText(wordApp,'<姓名>',objPerson.PatName);
			if (objPerson.PatSex=='') objPerson.PatSex='    '
			WordApp_ReplaceText(wordApp,'<性别>',objPerson.PatSex);
			if (objPerson.Age=='') objPerson.Age='  '
			WordApp_ReplaceText(wordApp,'<年龄>',objPerson.Age);
			if (objPerson.PapmiNo=='') objPerson.PapmiNo='        '
			WordApp_ReplaceText(wordApp,'<登记号>',objPerson.PapmiNo);
			if (objPaadm.AdmDate=='') objPaadm.AdmDate='        '
			WordApp_ReplaceText(wordApp,'<入院日期>',objPaadm.AdmDate);
			
			//wordApp.ActiveDocument.PrintOut();
			wordApp.ActiveDocument.PrintPreview();
			//wordApp.ActiveDocument.close();
		} catch (e) {
			alert(e.name + ": " + e.message);
		}
	} else {
		//通用 患者版表单打印
		var filePath = PrintPath + "DHCCPWFormToPatient\\通用模板.dot";
		if (IsExistsFile(filePath))
		{
			try {
				var wordDoc = wordApp.Documents.Open(filePath);
				wordApp.Visible = true;
				
				if (objCPW.CPWDesc=='') objCPW.CPWDesc='            '
				WordApp_ReplaceText(wordApp,'<路径名称>',objCPW.CPWDesc);
				if (objPerson.PatName=='') objPerson.PatName='        '
				WordApp_ReplaceText(wordApp,'<姓名>',objPerson.PatName);
				if (objPerson.PatSex=='') objPerson.PatSex='    '
				WordApp_ReplaceText(wordApp,'<性别>',objPerson.PatSex);
				if (objPerson.Age=='') objPerson.Age='  '
				WordApp_ReplaceText(wordApp,'<年龄>',objPerson.Age);
				if (objPerson.PapmiNo=='') objPerson.PapmiNo='        '
				WordApp_ReplaceText(wordApp,'<登记号>',objPerson.PapmiNo);
				if (objPaadm.AdmDate=='') objPaadm.AdmDate='        '
				WordApp_ReplaceText(wordApp,'<入院日期>',objPaadm.AdmDate);
				
				//wordApp.ActiveDocument.PrintOut();
				wordApp.ActiveDocument.PrintPreview();
			} catch (e) {
				alert(e.name + ": " + e.message);
			}
		}
	}
	
	//wordApp.Quit(0);
	//wordApp=null;
}

function IsExistsFile(filePath)
{
	var xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	xmlhttp.open("GET",filePath,false);
	xmlhttp.send();
	if(xmlhttp.readyState==4){
		if(xmlhttp.status==200){
			return true; //url存在
		}else if(xmlhttp.status==404) {
			return false; //url不存在
		}else{
			return false;//其他状态
		}
	}
	return false;
}

function WordApp_ReplaceText(wordApp,findText,replaceText)
{
	var Selection = wordApp.Selection;
	Selection.Find.Replacement.Text = '';
	Selection.Find.Forward = true;
	Selection.Find.Wrap = 1;
	Selection.Find.Format = false;
	Selection.Find.MatchCase = false;
	Selection.Find.MatchWholeWord = false;
	Selection.Find.MatchByte = true;
	Selection.Find.MatchWildcards = false;
	Selection.Find.MatchSoundsLike = false;
	Selection.Find.MatchAllWordForms = false;
	
	Selection.Find.ClearFormatting();
    Selection.Find.Text = findText;
    while(Selection.Find.Execute())
    {
    	Selection.TypeText(replaceText);
    }
    return;
}

//设置表单项目是否有效
function Common_SetDisabledToChkItems(elName,elValue,elStep,elFlag)
{
	var cpwItems=document.getElementsByName(elName);
	for (i=0;i<cpwItems.length;i++){
		var checkObj=cpwItems[i];
		if (checkObj.type=="checkbox"){
			if (elStep!='') {
				var StepRowid="";
				var tmpList=checkObj.id.split(",");
				if (tmpList.length>0){
					var tmpList1=tmpList[0].split("-");
				}else{
					var tmpList1=checkObj.id.split("-");
				}
				if (tmpList1.length>2){
					StepRowid=tmpList1[1];
				}else{
					var tmpList2=tmpList1[0].split("||");
					if (tmpList2.length>3){
						StepRowid=tmpList2[0] +"||" + tmpList2[1] + "||" + tmpList2[2];
					}
				}
				if (elFlag!='1')  //表示非当前步骤控制
				{
					if (StepRowid!=elStep) {
						checkObj.disabled=elValue;
					}
				} else {
					if (StepRowid==elStep) {
						checkObj.disabled=elValue;
					}
				}
			} else {
				checkObj.disabled=elValue;
			}
		}
	}
}

//设置表单项目子类是否有效
function Common_SetDisabledToChkCategs(elName,elValue,elStep,elFlag)
{
	var cpwItems=document.getElementsByName(elName);
	for (i=0;i<cpwItems.length;i++){
		var checkObj=cpwItems[i];
		if (checkObj.type=="checkbox"){
			if (elStep!='') {
				var StepRowid="";
				var tmpList=checkObj.id.split("-");
				if (tmpList.length>0){
					StepRowid=tmpList[0];
				}
				if (elFlag!='1')  //表示非当前步骤控制
				{
					if (StepRowid!=elStep) {
						checkObj.disabled=elValue;
					}
				} else {
					if (StepRowid==elStep) {
						checkObj.disabled=elValue;
					}
				}
			} else {
				checkObj.disabled=elValue;
			}
		}
	}
}

//设置表单时间调整项目是否有效
function Common_SetDisabledToChkEsts(elName,elValue,elStep,elFlag)
{
	var cpwItems=document.getElementsByName(elName);
	for (i=0;i<cpwItems.length;i++){
		var checkObj=cpwItems[i];
		if (checkObj.type=="checkbox"){
			if (elStep!='') {
				var StepRowid="";
				var tmpList=checkObj.id.split("/");
				if (tmpList.length>0){
					StepRowid=tmpList[0];
				}
				if (elFlag!='1')  //表示非当前步骤控制
				{
					if (StepRowid!=elStep) {
						checkObj.disabled=elValue;
					}
				} else {
					if (StepRowid==elStep) {
						checkObj.disabled=elValue;
					}
				}
			} else {
				checkObj.disabled=elValue;
			}
		}
	}
}

var ReturnValue = "";
function getStepItemIDStr()
{
	var objChild = document.getElementById("docOrderEntry");
	if (objChild) {
		ReturnValue = objChild.contentWindow.getStepItemIDStr();
	} else {
		ReturnValue = "";
	}
}
