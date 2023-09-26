var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_ER=String.fromCharCode(13)+String.fromCharCode(10);
var separete="&nbsp;";

function InitMainViewportEvent(obj) {
	obj.LoadEvent = function(args){
		//加载科室常用路径分组列表
		obj.LocPathWayQryArg1=obj.CurrLogon.CTLOCID;
		obj.LocPathWayGridStore.load({
			callback: function(records, options, success){
				obj.LocPathWayGrid.getView().expandAllGroups();
			}
			,scope: obj.LocPathWayGridStore
			,add: false
		});
		//加载帮助文档
		if (obj.CurrClinPathWay){
			obj.SelectCPWID=obj.CurrClinPathWay.CPWDR;
		}
		obj.LoadHelpDocument();
		//初始化帮助文档模板高度
		obj.HelpDocumentPanel.setHeight(Ext.getCmp('InPathWayPanel').getSize().height-45);
		obj.PathWaySelectPanel.setHeight(Ext.getCmp('InPathWayPanel').getSize().height-45);
		//科室常用路径列表行单击事件
		obj.LocPathWayGrid.on("rowclick", obj.LocPathWayGrid_OnRowClick, obj);
		//出入径列表行双击事件
		obj.PathWayGridPanel.on("rowdblclick", obj.PathWayGridPanel_OnRowClick, obj);
		//设置入径按钮和查看表单按钮状态
		Ext.getCmp("btnInPathWay").setVisible(!obj.CurrClinPathWay);
		//update by zf 20120313
		//Ext.getCmp("btFormDisplay").setVisible(!obj.CurrClinPathWay);
		//入径按钮操作
		Ext.getCmp("btnInPathWay").on("click", obj.btnInPathWay_OnClick, obj);
		//查看表单按钮操作
		Ext.getCmp("btFormDisplay").on("click", obj.btFormDisplay_OnClick, obj);
		//Add By Niucaicai 2011-8-5
		if (obj.CurrPaPerson.PatDeceased == "Y")
		{
			ExtTool.alert("提示","死亡患者不允许入径!");
			Ext.getCmp("btnInPathWay").setVisible(false);
		}
		if (obj.CurrPAADM.AdmType!="I")
		{
			ExtTool.alert("提示","非住院患者不允许入径!");
			Ext.getCmp("btnInPathWay").setVisible(false);
		}
		if (obj.CurrPAADM.AdmStatus!="在院")
		{
			ExtTool.alert("提示","出院患者不允许入径!");
			Ext.getCmp("btnInPathWay").setVisible(false);
		}
		
		setTimeout('objScreen.AutoLinkFormWindow()',500);
	};
	
	obj.AutoLinkFormWindow = function(){
		//加载出入径列表
		obj.PathWayGridPanelStore.load({
			callback : function(record,response,success) {
				if (success){
					if (record.length>0){
						//如果通过菜单进入，如果入径患者，直接转到表单页面
						//如果从表单转入页面
						if ((obj.CurrClinPathWay)&&(!BackPage)){
							LinkFormWindow(obj.CurrClinPathWay.Rowid);
						}
					}
				}
			}
		});
	}
	
	//科室常用路径列表行单击事件
	obj.LocPathWayGrid_OnRowClick=function(){
		if (obj.CurrClinPathWay){
			obj.SelectCPWID=obj.CurrClinPathWay.CPWDR;
			ExtTool.alert("提示","当前患者已入径,不允许重复入径!");
			return;
		}else{
			var rowIndex = arguments[1];
			var objRec = obj.LocPathWayGridStore.getAt(rowIndex);
			
			//update by zf 2012-10-10
			//处理准入提示符合多条路径问题
			if ((obj.InitCPWID!='')&&(objRec.get("CPWID")!=obj.InitCPWID))
			{
				var InitFlag = false;
				var strCPWID = obj.InitCPWID;
				var arrCPWID = strCPWID.split(String.fromCharCode(2));
				for(var indCPWID=0; indCPWID<arrCPWID.length; indCPWID++){
					if(arrCPWID[indCPWID] == objRec.get("CPWID")) {
						InitFlag = true;
					}
				}
				
				if (!InitFlag) {
					var strCPWDesc = obj.InitCPWDesc;
					strCPWDesc = strCPWDesc.replace(String.fromCharCode(2),";");
					if(confirm("准入提示路径 " + strCPWDesc + " ,与当前选择路径不同,是否确认选择当前路径?"))
					{
						obj.SelectCPWID=objRec.get("CPWID");
					}else{
						obj.SelectCPWID=arrCPWID[0];
					}
				}else{
					obj.SelectCPWID=objRec.get("CPWID");
				}
			}else{
				obj.SelectCPWID=objRec.get("CPWID");
			}
			
			obj.LoadHelpDocument();
		}
	}
	
	//加载帮助文档模板的内容
	obj.LoadHelpDocument=function(){
		var helpDocument="";
		var objcpw = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysSrv");
		if (obj.CurrClinPathWay){
			//当前路径说明文档
			helpDocument=objcpw.GetHelpById(obj.CurrClinPathWay.CPWDR);
			if (helpDocument=="")
			{
				helpDocument="<SPAN style='FONT-FAMILY: 楷体_GB2312; FONT-SIZE: 16pt'>" + obj.CurrClinPathWay.CPWDesc + "</SPAN><br>";
			}
		}else if (obj.SelectCPWID) {
			//特定路径介绍文档
			helpDocument=objcpw.GetHelpById(obj.SelectCPWID);
			if (helpDocument!=""){
				//*******	Modified by zhaoyu 2012-11-26 基础信息维护-路径表单维护-【文档】中设置了字体倾斜和加粗后，在医生查看的帮助文档中无效 169
				var helpDocuRepl = helpDocument;
				while(helpDocuRepl.indexOf("<STRONG>")>0){
					helpDocuRepl = helpDocuRepl.replace("<STRONG>","<b>");
				}
				while(helpDocuRepl.indexOf("</STRONG>")>0){
					helpDocuRepl = helpDocuRepl.replace("</STRONG>","</b>");
				}
				while(helpDocuRepl.indexOf("<EM>")>0){
					helpDocuRepl = helpDocuRepl.replace("<EM>","<i>");
				}
				while(helpDocuRepl.indexOf("</EM>")>0){
					helpDocuRepl = helpDocuRepl.replace("</EM>","</i>");
				}
				helpDocument="<SPAN style='FONT-FAMILY: 楷体_GB2312; FONT-SIZE: 16pt'>" + helpDocuRepl + "</SPAN><br>";
				//helpDocument="<SPAN style='FONT-FAMILY: 楷体_GB2312; FONT-SIZE: 16pt'>" + helpDocument + "</SPAN><br>";
				//*******
			}
		}else{
			//
		}
		//路径总体介绍文档
		var allHelpDesc="";
		//特定路径介绍文档
		var objcpw = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysSrv");
		var selHelpDoc=objcpw.GetHelpById(obj.SelectCPWID);
		//加载帮助文档数据
		var tplHelpDocData={
			helpDocument:helpDocument
		};
		obj.tplHelpDoc.compile();
		obj.tplHelpDoc.overwrite(obj.HelpDocumentPanel.body,tplHelpDocData);
	}
	
	//出入径列表行双击事件
	obj.PathWayGridPanel_OnRowClick=function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.PathWayGridPanelStore.getAt(rowIndex);
		var PathWayID=objRec.get("Rowid");
		LinkFormWindow(PathWayID);
	}
	
	//入径操作函数
	obj.btnInPathWay_OnClick=function()
	{
		var InputErr="",InputSign="";
		if (obj.CurrClinPathWay){ return; }  //已经入径，不允许重复入径
		var cpwRowid=obj.SelectCPWID;
		var cpwStepId="";
		if (!cpwRowid){ return; }  //没有选择路径，不允许入径
		
		/*add by np 20170619 判断是否有该路径下对应诊断*/
		var IsCPWICD = ExtTool.RunServerMethod("web.DHCCPW.MR.ClinicalPathWays","GetIsCPWICD",obj.CurrPAADM.MRAdm,cpwRowid)
		if (IsCPWICD<1) {
			ExtTool.alert("提示", "没有该路径对应的诊断，不允许入此路径!");
			return;
		}
		/*add by niepeng 20170608 同一病人再次入同一路径需要选择再入径原因*/
		var MRPathWayNP= ExtTool.StaticServerObject("web.DHCCPW.MR.ClinicalPathWays");
		var OldPathWayID = MRPathWayNP.GetOldPathWayID(obj.CurrPAADM.MRAdm);
		var InitFlag=false
		var arrCPWID = OldPathWayID.split("^");
		for(var indCPWID=0; indCPWID<arrCPWID.length; indCPWID++){
			if(arrCPWID[indCPWID] == cpwRowid) {
				InitFlag = true;
			}
		}
		var InPathAgainID="";
		if (InitFlag){
			var Ret=confirm("该病人曾入过这种路径，是否再次入径?");
			if (Ret){
				var path="dhccpw.mr.inpathagain.csp?EpisodeID=" + EpisodeID +
					"&VersionID=" + cpwRowid;
				var retValue = window.showModalDialog(
						path,
						"",
						"dialogHeight: 420px; dialogWidth: 600px");
				
				if (retValue>0) {
					InPathAgainID = retValue;					
				}else {
					ExtTool.alert("提示", "未填写再入径原因，不允许入此路径!");
					return;
				}
			}else{
				return;
			}
		}
		
		/*end*/
		var mrInterface = ExtTool.StaticServerObject("web.DHCCPW.MR.Interface");
		var cpwName = mrInterface.GetInPathWayName(EpisodeID);
		if (cpwName) { return; }
		Ext.getCmp("btnInPathWay").setVisible(false);
		
		var InDoctor="",InDate="",InTime="";
		var ctpcpService = ExtTool.StaticServerObject("web.DHCCPW.MR.CTCareProvSrv");
		var docString=ctpcpService.GetCareProvByUserID(obj.CurrLogon.USERID,"^");
		InDoctor=docString.split("^")[0];
		
		//1:Rowid 2:MRADMDR 3:PathwayDR 4:PathwayEpStepDR 5:Status 6:InDoctorDR
		//7:InDate 8:InTime 9:OutDoctorDR 10:OutDate 11:OutTime 12:UpdateDate
		//13:UpdateTime 14:OutReasonDR 15:Comments 16:UpdateUserDR
		
		var InputStr="";
		InputStr=InputStr + "^" + obj.CurrPAADM.MRAdm;
		InputStr=InputStr + "^" + cpwRowid; //obj.CurrClinPathWay.CPWDR;
		InputStr=InputStr + "^" + cpwStepId; //obj.CurrClinPathWay.CPWEpStepDR;
		InputStr=InputStr + "^" + "I";
		InputStr=InputStr + "^" + InDoctor;
		InputStr=InputStr + "^" ; //+ InDate;
		InputStr=InputStr + "^" ; //+ InTime;
		InputStr=InputStr + "^";
		InputStr=InputStr + "^";
		InputStr=InputStr + "^";
		InputStr=InputStr + "^";
		InputStr=InputStr + "^";
		InputStr=InputStr + "^";
		InputStr=InputStr + "^"; // + obj.txtaResume.getValue();
		InputStr=InputStr + "^" + obj.CurrLogon.USERID;
		var objMRClinicalPathWays = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinicalPathWays");
		var ret = objMRClinicalPathWays.InPathWay(InputStr);
		if (ret<0){
			ExtTool.alert("提示","入径操作失败!",Ext.MessageBox.ERROR);
		}else{
			var logID = ExtTool.GetParam(window,"LogID");
			var objInPathLogSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWayInPathLogSrv");
			objInPathLogSrv.UpdateLogResult(logID,ret);
			objInPathLogSrv.UpdateLogResult(InPathAgainID,ret); //更新再入径原因日志记录中的入径记录ID
			LinkFormWindow(ret);
		}
	}
	
	//查看表单操作函数
	obj.btFormDisplay_OnClick=function(){
		CPWFormShowHeaderNew(obj.SelectCPWID);
	}
}

function PrintInformedConsert(objCPW,objPerson,objPaadm)
{
	//if ((!objCPW)||(!objPerson)||(!objPaadm)) return;
	//var PathWayName=objCPW.CPWDesc;
	//if (!PathWayName) return;
	if ((!objPerson)||(!objPaadm)) return;
	
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
	
	var filePath = PrintPath + "DHCCPWInformedConsert.dot";
	if (IsExistsFile(filePath))
	{
		try {
			var wordDoc = wordApp.Documents.Open(filePath);
			//wordApp.Application.Visible = false;
			wordApp.Visible = true;
			if (objPerson.PatName=='') objPerson.PatName='        '
			WordApp_ReplaceText(wordApp,'<姓名>',objPerson.PatName);
			if (objPerson.PatSex=='') objPerson.PatSex='    '
			WordApp_ReplaceText(wordApp,'<性别>',objPerson.PatSex);
			if (objPerson.Age=='') objPerson.Age='    '
			WordApp_ReplaceText(wordApp,'<年龄>',objPerson.Age);
			if (objPerson.Medicare=='') objPerson.Medicare='        '
			WordApp_ReplaceText(wordApp,'<病案号>',objPerson.Medicare);
			if (objPaadm.AdmWard=='') objPaadm.AdmWard='        '
			WordApp_ReplaceText(wordApp,'<病区>',objPaadm.AdmWard);
			if (objPaadm.AdmBed=='') objPaadm.AdmBed='    '
			WordApp_ReplaceText(wordApp,'<床号>',objPaadm.AdmBed);
			
			wordApp.ActiveDocument.PrintPreview();
			//wordApp.ActiveDocument.close();
		} catch (e) {
			alert(e.name + ": " + e.message);
		}
	}else{
		wordApp.Quit(0);
		wordApp=null;
	}
}

function PrintSatisfactionSurvey(objCPW,objPerson,objPaadm)
{
	//if ((!objCPW)||(!objPerson)||(!objPaadm)) return;
	//var PathWayName=objCPW.CPWDesc;
	//if (!PathWayName) return;
	if ((!objPerson)||(!objPaadm)) return;
	
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
	
	var filePath = PrintPath + "DHCCPWSatisfactionSurvey.dot";
	if (IsExistsFile(filePath))
	{
		try {
			var wordDoc = wordApp.Documents.Open(filePath);
			//wordApp.Application.Visible = false;
			wordApp.Visible = true;
			
			
			if (objPerson.PatName=='') objPerson.PatName='        '
			WordApp_ReplaceText(wordApp,'<姓名>',objPerson.PatName);
			if (objPerson.PatSex=='') objPerson.PatSex='    '
			if (objPerson.Medicare=='') objPerson.Medicare='        '
			WordApp_ReplaceText(wordApp,'<病历号>',objPerson.Medicare);
			if (objPaadm.AdmLoc=='') objPaadm.AdmLoc='        '
			WordApp_ReplaceText(wordApp,'<入院科室>',objPaadm.AdmLoc);
			if (objPaadm.AdmDate=='')
			{
				WordApp_ReplaceText(wordApp,'<入院日期>','0000年00月00日');
			} else {
				var strAdmDate = objPaadm.AdmDate;
				var arrAdmDate = strAdmDate.split('-');
				WordApp_ReplaceText(wordApp,'<入院日期>',arrAdmDate[0] + '年' + arrAdmDate[1] + '月'+ arrAdmDate[2] +'日');
			}
			var currDate = new Date();
			WordApp_ReplaceText(wordApp,'<打印日期>',currDate.getFullYear() + '年' + (currDate.getMonth() + 1) + '月'+ currDate.getDate() +'日');
			
			wordApp.ActiveDocument.PrintPreview();
			//wordApp.ActiveDocument.close();
		} catch (e) {
			alert(e.name + ": " + e.message);
		}
	}else{
		wordApp.Quit(0);
		wordApp=null;
	}
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
