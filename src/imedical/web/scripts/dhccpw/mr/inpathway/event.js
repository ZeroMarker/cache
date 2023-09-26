var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_ER=String.fromCharCode(13)+String.fromCharCode(10);
var separete="&nbsp;";

function InitMainViewportEvent(obj) {
	obj.LoadEvent = function(args){
		//���ؿ��ҳ���·�������б�
		obj.LocPathWayQryArg1=obj.CurrLogon.CTLOCID;
		obj.LocPathWayGridStore.load({
			callback: function(records, options, success){
				obj.LocPathWayGrid.getView().expandAllGroups();
			}
			,scope: obj.LocPathWayGridStore
			,add: false
		});
		//���ذ����ĵ�
		if (obj.CurrClinPathWay){
			obj.SelectCPWID=obj.CurrClinPathWay.CPWDR;
		}
		obj.LoadHelpDocument();
		//��ʼ�������ĵ�ģ��߶�
		obj.HelpDocumentPanel.setHeight(Ext.getCmp('InPathWayPanel').getSize().height-45);
		obj.PathWaySelectPanel.setHeight(Ext.getCmp('InPathWayPanel').getSize().height-45);
		//���ҳ���·���б��е����¼�
		obj.LocPathWayGrid.on("rowclick", obj.LocPathWayGrid_OnRowClick, obj);
		//���뾶�б���˫���¼�
		obj.PathWayGridPanel.on("rowdblclick", obj.PathWayGridPanel_OnRowClick, obj);
		//�����뾶��ť�Ͳ鿴����ť״̬
		Ext.getCmp("btnInPathWay").setVisible(!obj.CurrClinPathWay);
		//update by zf 20120313
		//Ext.getCmp("btFormDisplay").setVisible(!obj.CurrClinPathWay);
		//�뾶��ť����
		Ext.getCmp("btnInPathWay").on("click", obj.btnInPathWay_OnClick, obj);
		//�鿴����ť����
		Ext.getCmp("btFormDisplay").on("click", obj.btFormDisplay_OnClick, obj);
		//Add By Niucaicai 2011-8-5
		if (obj.CurrPaPerson.PatDeceased == "Y")
		{
			ExtTool.alert("��ʾ","�������߲������뾶!");
			Ext.getCmp("btnInPathWay").setVisible(false);
		}
		if (obj.CurrPAADM.AdmType!="I")
		{
			ExtTool.alert("��ʾ","��סԺ���߲������뾶!");
			Ext.getCmp("btnInPathWay").setVisible(false);
		}
		if (obj.CurrPAADM.AdmStatus!="��Ժ")
		{
			ExtTool.alert("��ʾ","��Ժ���߲������뾶!");
			Ext.getCmp("btnInPathWay").setVisible(false);
		}
		
		setTimeout('objScreen.AutoLinkFormWindow()',500);
	};
	
	obj.AutoLinkFormWindow = function(){
		//���س��뾶�б�
		obj.PathWayGridPanelStore.load({
			callback : function(record,response,success) {
				if (success){
					if (record.length>0){
						//���ͨ���˵����룬����뾶���ߣ�ֱ��ת����ҳ��
						//����ӱ�ת��ҳ��
						if ((obj.CurrClinPathWay)&&(!BackPage)){
							LinkFormWindow(obj.CurrClinPathWay.Rowid);
						}
					}
				}
			}
		});
	}
	
	//���ҳ���·���б��е����¼�
	obj.LocPathWayGrid_OnRowClick=function(){
		if (obj.CurrClinPathWay){
			obj.SelectCPWID=obj.CurrClinPathWay.CPWDR;
			ExtTool.alert("��ʾ","��ǰ�������뾶,�������ظ��뾶!");
			return;
		}else{
			var rowIndex = arguments[1];
			var objRec = obj.LocPathWayGridStore.getAt(rowIndex);
			
			//update by zf 2012-10-10
			//����׼����ʾ���϶���·������
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
					if(confirm("׼����ʾ·�� " + strCPWDesc + " ,�뵱ǰѡ��·����ͬ,�Ƿ�ȷ��ѡ��ǰ·��?"))
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
	
	//���ذ����ĵ�ģ�������
	obj.LoadHelpDocument=function(){
		var helpDocument="";
		var objcpw = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysSrv");
		if (obj.CurrClinPathWay){
			//��ǰ·��˵���ĵ�
			helpDocument=objcpw.GetHelpById(obj.CurrClinPathWay.CPWDR);
			if (helpDocument=="")
			{
				helpDocument="<SPAN style='FONT-FAMILY: ����_GB2312; FONT-SIZE: 16pt'>" + obj.CurrClinPathWay.CPWDesc + "</SPAN><br>";
			}
		}else if (obj.SelectCPWID) {
			//�ض�·�������ĵ�
			helpDocument=objcpw.GetHelpById(obj.SelectCPWID);
			if (helpDocument!=""){
				//*******	Modified by zhaoyu 2012-11-26 ������Ϣά��-·����ά��-���ĵ�����������������б�ͼӴֺ���ҽ���鿴�İ����ĵ�����Ч 169
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
				helpDocument="<SPAN style='FONT-FAMILY: ����_GB2312; FONT-SIZE: 16pt'>" + helpDocuRepl + "</SPAN><br>";
				//helpDocument="<SPAN style='FONT-FAMILY: ����_GB2312; FONT-SIZE: 16pt'>" + helpDocument + "</SPAN><br>";
				//*******
			}
		}else{
			//
		}
		//·����������ĵ�
		var allHelpDesc="";
		//�ض�·�������ĵ�
		var objcpw = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysSrv");
		var selHelpDoc=objcpw.GetHelpById(obj.SelectCPWID);
		//���ذ����ĵ�����
		var tplHelpDocData={
			helpDocument:helpDocument
		};
		obj.tplHelpDoc.compile();
		obj.tplHelpDoc.overwrite(obj.HelpDocumentPanel.body,tplHelpDocData);
	}
	
	//���뾶�б���˫���¼�
	obj.PathWayGridPanel_OnRowClick=function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.PathWayGridPanelStore.getAt(rowIndex);
		var PathWayID=objRec.get("Rowid");
		LinkFormWindow(PathWayID);
	}
	
	//�뾶��������
	obj.btnInPathWay_OnClick=function()
	{
		var InputErr="",InputSign="";
		if (obj.CurrClinPathWay){ return; }  //�Ѿ��뾶���������ظ��뾶
		var cpwRowid=obj.SelectCPWID;
		var cpwStepId="";
		if (!cpwRowid){ return; }  //û��ѡ��·�����������뾶
		
		/*add by np 20170619 �ж��Ƿ��и�·���¶�Ӧ���*/
		var IsCPWICD = ExtTool.RunServerMethod("web.DHCCPW.MR.ClinicalPathWays","GetIsCPWICD",obj.CurrPAADM.MRAdm,cpwRowid)
		if (IsCPWICD<1) {
			ExtTool.alert("��ʾ", "û�и�·����Ӧ����ϣ����������·��!");
			return;
		}
		/*add by niepeng 20170608 ͬһ�����ٴ���ͬһ·����Ҫѡ�����뾶ԭ��*/
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
			var Ret=confirm("�ò������������·�����Ƿ��ٴ��뾶?");
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
					ExtTool.alert("��ʾ", "δ��д���뾶ԭ�򣬲��������·��!");
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
			ExtTool.alert("��ʾ","�뾶����ʧ��!",Ext.MessageBox.ERROR);
		}else{
			var logID = ExtTool.GetParam(window,"LogID");
			var objInPathLogSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWayInPathLogSrv");
			objInPathLogSrv.UpdateLogResult(logID,ret);
			objInPathLogSrv.UpdateLogResult(InPathAgainID,ret); //�������뾶ԭ����־��¼�е��뾶��¼ID
			LinkFormWindow(ret);
		}
	}
	
	//�鿴����������
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
		alert(e.name + ": " + e.message +',���ܴ���Word������߿ͻ���û�а�װWord���!');
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
			WordApp_ReplaceText(wordApp,'<����>',objPerson.PatName);
			if (objPerson.PatSex=='') objPerson.PatSex='    '
			WordApp_ReplaceText(wordApp,'<�Ա�>',objPerson.PatSex);
			if (objPerson.Age=='') objPerson.Age='    '
			WordApp_ReplaceText(wordApp,'<����>',objPerson.Age);
			if (objPerson.Medicare=='') objPerson.Medicare='        '
			WordApp_ReplaceText(wordApp,'<������>',objPerson.Medicare);
			if (objPaadm.AdmWard=='') objPaadm.AdmWard='        '
			WordApp_ReplaceText(wordApp,'<����>',objPaadm.AdmWard);
			if (objPaadm.AdmBed=='') objPaadm.AdmBed='    '
			WordApp_ReplaceText(wordApp,'<����>',objPaadm.AdmBed);
			
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
		alert(e.name + ": " + e.message +',���ܴ���Word������߿ͻ���û�а�װWord���!');
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
			WordApp_ReplaceText(wordApp,'<����>',objPerson.PatName);
			if (objPerson.PatSex=='') objPerson.PatSex='    '
			if (objPerson.Medicare=='') objPerson.Medicare='        '
			WordApp_ReplaceText(wordApp,'<������>',objPerson.Medicare);
			if (objPaadm.AdmLoc=='') objPaadm.AdmLoc='        '
			WordApp_ReplaceText(wordApp,'<��Ժ����>',objPaadm.AdmLoc);
			if (objPaadm.AdmDate=='')
			{
				WordApp_ReplaceText(wordApp,'<��Ժ����>','0000��00��00��');
			} else {
				var strAdmDate = objPaadm.AdmDate;
				var arrAdmDate = strAdmDate.split('-');
				WordApp_ReplaceText(wordApp,'<��Ժ����>',arrAdmDate[0] + '��' + arrAdmDate[1] + '��'+ arrAdmDate[2] +'��');
			}
			var currDate = new Date();
			WordApp_ReplaceText(wordApp,'<��ӡ����>',currDate.getFullYear() + '��' + (currDate.getMonth() + 1) + '��'+ currDate.getDate() +'��');
			
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
			return true; //url����
		}else if(xmlhttp.status==404) {
			return false; //url������
		}else{
			return false;//����״̬
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
