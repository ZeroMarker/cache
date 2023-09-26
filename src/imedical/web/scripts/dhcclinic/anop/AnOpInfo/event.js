

function InitViewScreenEvent(obj)
{ 
	var _DHCANOPCom=ExtTool.StaticServerObject('web.DHCANOPCom');	
	var _DHCANRecord=ExtTool.StaticServerObject('web.DHCANRecord');
	var _UDHCANOPArrange=ExtTool.StaticServerObject('web.UDHCANOPArrange');
	var _UDHCANOPSET=ExtTool.StaticServerObject('web.UDHCANOPSET');
	var _DHCCLCom=ExtTool.StaticServerObject('web.DHCCLCom');
	var _DHCLCNUREXCUTE=ExtTool.StaticServerObject('web.DHCLCNUREXCUTE');
	var _DHCANOPArrange=ExtTool.StaticServerObject('web.DHCANOPArrange');
	var intReg=/^[1-9]\d*$/;
	var SelectNum=0;
	obj.LoadEvent = function(args)
	{
		var isSet=false
		var win=top.frames['eprmenu'];
		if (win)
		{
			var frm = win.document.forms['fEPRMENU'];
			if (frm)
			{
				var EpisodeID=frm.EpisodeID.value; 
				var PatientID=frm.PatientID.value; 
			var mradm=frm.mradm.value;
				isSet=true
			}
		}
		if (isSet==false)
		{
			var frm =dhcsys_getmenuform();
			if (frm) { var EpisodeID=frm.EpisodeID.value;
			var PatientID=frm.PatientID.value; 
			var mradm=frm.mradm.value;}
		}
		obj.EpisodeID.setValue(EpisodeID)
		var userId=session['LOGON.USERID'];
		//��ѯ��ʼ����ʱ��
		var ret=_DHCANOPCom.GetInitialDate(session['LOGON.USERID'],"",session['LOGON.CTLOCID']);
		obj.dateFrm.setValue(ret);
		obj.dateTo.setValue(ret);
		//20120531+dyl+�����Ĭ�ϲ�ѯʱ��Ϊ��ǰ����������
		var GROUPDESC=session['LOGON.GROUPDESC'];
		if(GROUPDESC=='����ҽ��')
		{
			var ret=_DHCANOPCom.GetInitialDateTow(session['LOGON.USERID'],"",session['LOGON.CTLOCID']);
			obj.dateTo.setValue(ret);
		}
		try
		{
			var ipset=new ActiveXObject("rcbdyctl.Setting"); 
			var localIPAddress="";
			localIPAddress=ipset.GetIPAddress;
			var retRoomStr=_DHCANOPCom.GetRoomIdByIp(localIPAddress);
			if(retRoomStr!="")
			{
	
				Ext.getCmp("comOpRoom").getStore().load({
					params : {
						start : 0,
						limit : 10,
						desc : retRoomStr.split("^")[1]
					},
					callback : function() {
						Ext.getCmp("comOpRoom").setValue(retRoomStr.split("^")[0])
					}
				})				
			}
		}
	    catch(e){}
	    var loc="^".split("^");
	    var ret=_UDHCANOPArrange.GetDocLoc(userId)
	    if (ret!="")
	    {
			loc=ret.split("^");
	    }  
	    if(obj.comAppLoc.getRawValue()=="") obj.loc.setValue("");
	    var userType="";
	    userType=_DHCANOPCom.GetUserType(userId);
	    var logUserType=""; //lonon user type: ANDOCTOR,ANNURSE,OPNURSE
	    var sessLoc=session['LOGON.CTLOCID'];
	    obj.userLocId.setValue(sessLoc);
	    var logLocType="App"
	    var ret=_UDHCANOPSET.ifloc(sessLoc);
	    //alert(ret)
	    if ((ret!=1)&&(ret!=2))   //������:ret=1,�����:ret=2
	    {
			
			obj.comAppLoc.setValue(loc[1]);
			Ext.getDom("comAppLoc").value=loc[0];			
			obj.loc.setValue(loc[1]);
			if (userType=="NURSE") 
			{
				if(obj.comAppLoc.getRawValue()=="")
				{
					var ret=_DHCCLCom.GetLinkLocId(sessLoc)
					obj.loc.setValue(ret);
				}
			}
		}
		else
		{
			if ((ret==1)&&(userType=="NURSE"))  logUserType="OPNURSE";
			if ((ret==2)&&(userType=="NURSE"))	logUserType="ANNURSE";
			if ((ret==2)&&(userType=="DOCTOR"))	logUserType="ANDOCTOR";
			if(ret==1) logLocType="OP";
			if(ret==2) logLocType="AN";
			obj.comAppLoc.setValue("");
			obj.loc.setValue("");
		}
		if(logLocType=="OP")
		{ 
			obj.tb.addItem({
			xtype: 'tbspacer', 
			width: 500
			});
		}
		if(logLocType=="AN")
		{  
		}
		if(logLocType=="App")
		{ 
		}
		var groupId=session['LOGON.GROUPID'];
		/*var buttonStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
		var buttonStore = new Ext.data.Store({
			proxy: buttonStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'name'
			}, 
			[{name: 'name', mapping: 'name'}
			,{name: 'caption', mapping: 'caption'}
			])
		});
		buttonStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANOPArrange';
			param.QueryName = 'GetGroupConfig';
			param.Arg1 = 'BUTTON';
			param.Arg2 = groupId;
			param.ArgCnt = 2;
		})
		buttonStore.load({
			callback:function(records,options,sunccess)
			{
				for(var i=0;i<records.length;i++)
				{
					var btn = new Ext.Button({
						id : records[i].data.name
						,text : records[i].data.caption
						,handler:OnButtonClick
					});					
					obj.tb.addButton(btn);
					obj.tb.doLayout();
				}
			}
		})	*/
		obj.tb.doLayout();	//ˢ�¹�����
		var menuStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
		var menuStore = new Ext.data.Store({
			proxy: menuStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'name'
			}, 
			[  {name: 'name', mapping: 'name'}
				,{name: 'caption', mapping: 'caption'}
				,{name: 'handler', mapping: 'handler'}
			])
		});
		menuStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANOPArrange';
			param.QueryName = 'GetGroupConfig';
			param.Arg1 = 'MENU';
			param.Arg2 = groupId;
			param.ArgCnt = 2;
		})
		menuStore.load({
			callback : function(records, options, success) 
			{
				for(var i=0;i<records.length;i++)
				{
					var item = new Ext.menu.Item({
						text : records[i].data.caption,
						id : records[i].data.name,
						handler:OnMenuClick
					});					
					obj.opManageMenu.addItem(item);
				}
			}
	   	})
		obj.logUserType.setValue(logUserType);
		obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANRecord';
			param.QueryName = 'GetAnOpList';
			param.Arg1 = obj.dateFrm.getRawValue();
			param.Arg2 = obj.dateTo.getRawValue();
			param.Arg3 = obj.comOperStat.getValue();
			param.Arg4 = obj.comOpRoom.getValue();
			//alert(obj.comAppLoc.getRawValue())
			if(obj.comAppLoc.getRawValue()=="")
			{
				obj.loc.setValue("");
			}
			param.Arg5 = obj.loc.getValue();
			param.Arg6 = '';
			param.Arg7 = obj.userLocId.getValue();
			param.Arg8 = obj.chkIsAppT.getValue()?'1':'0';
			param.Arg9 = obj.txtMedCareNo.getValue();
			param.Arg10 = obj.comOprFloor.getValue();
			param.Arg11 = obj.comPatWard.getValue();
			param.Arg12 = ""; //obj.chkUnPaidOp.getValue()?'Y':'N';
			param.Arg13 = logUserType;
			param.Arg14 = obj.chkIfAllLoc.getValue()?'Y':'N';
			param.ArgCnt = 14;
		});
		obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:200
			}
		});  
	}
	
	var objtxtMedCareNo=document.getElementById("txtMedCareNo");
	if (objtxtMedCareNo)
	{
		objtxtMedCareNo.onkeydown=LookUptxtMedCareNo;
	} 
	function LookUptxtMedCareNo()
	{
	if (window.event.keyCode==13) 
		{  
		window.event.keyCode=117;
	   	obj.btnSch_click();
		}
	}
	
	
	
	
	
	OnButtonClick = function()
	{	
		switch(arguments[0].id)
		{
			case 'opEquipment':
			    opEquipment_click();
				break;
			case 'btnOpRoomLimit': //�й�ҽ����
				btnOpRoomLimit_click();
				break;
			default:
				break;
		}
	}
	
	OnMenuClick = function()
	{
	  	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=UDHCANOPAPP";
		var nwin="Height=700,Width=960,top=0,left=0,scrollbars=yes";
		switch(arguments[0].id)
		{
		  	case "AppOper":
				AppNewOper('ward',lnk,nwin);
				break;
		    case "AlterOper":
				ManageOper('ward',lnk,nwin);
				break;
		    case "ArrOper":
				ManageOper('op',lnk,nwin);
				break;	
		    case "RefuseOper":
				RefuseOper();
				break;
		    case "CancelRef":
				CancelRefusedOper();
				break;
		    case "ArrAn":		         
				ManageOper('anaes',lnk,nwin);	
				break;
		    case "MonAn":
				AnAtOperation();
				break;
			case "AnConsent":
				AnAtOperation("AC");
				break;
			case "PreOpAssessment":
				AnAtOperation("AMT");
				break;
			case "PostOpRecord":
				AnAtOperation("PAV");
				break;
			case "AnRecord":
				AnAtOperation("ANI");
				break;
			case "PACURecord":
				AnAtOperation("PACU");
				break;	
			case "AnPdfDisplay":
				AnPdfDisplay();
				break;
		    case "ANOPCount":
				ANOPCount();
				break;
		    case "RegOper":
				ManageOper('RegOp',lnk,nwin);
				break;
		    case "PrintSQD":
				PrintAnOpList("SQD","N");
				break;
		    case "PrintSSD":
				PrintAnOpList("SSD","N");
				break;
		    case "PrintMZD":
				PrintAnOpList("MZD","N");
				break;
 			case "CancelOper":
				CancelOper();
				break;
			case 'btnAnDocOrdered':
				btnAnDocOrdered_click();
			break;

		    default:
				break;
		}
	}
	//��������
	function CancelOper()
	{	
		if(CheckNum()>1)
		{
			alert("ֻ�ܳ���һ������,������ѡ��");
			return;
		}
	    var count=obj.retGridPanelStore.getCount();//��������
		var idStr="",invalCol="";
		var tmp=new Array();
		var colNum=new Array();
		var invNum=new Array();
		for (var i=0;i<count;i++)
		{
			var sel=""
			var record=obj.retGridPanelStore.getAt(i);
			sel=record.get('checked');
			var status=record.get('status');
			var opaId=record.get('opaId');
			if(sel==true)
			{
				var num=i+1;				
				if((status!='����')&&(status!='����')&&session['LOGON.GROUPDESC']=="������ʿ")
				{
					invNum[invNum.length]=i
					continue;
				}
				tmp[tmp.length]=i;
				colNum[colNum.length]=i+1;
				if(idStr=="") idStr=opaId;
				else idStr=idStr+"^"+opaId;
			}
		}
		if(idStr=="")
		{
			alert("��ѡ��״̬Ϊ������ŵ�������");
			for(var j=0;j<=invNum.length;j++)
			{
				var index=invNum[j];
				record=obj.retGridPanelStore.getAt(index);
				record.set('checked','');
			}
			return;
		} 
		else
		{
			var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
			if (selectObj)
			{
				var status=selectObj.get('status');
				if(((status!='����')&&(session['LOGON.GROUPDESC']=="Inpatient Doctor"))||((status!='����')&&(session['LOGON.GROUPDESC']=="סԺҽ��")))
				{
					alert("��Ȩ�޶Դ�״̬����������");
					return;
				}
			}
			var ifClear=confirm("�Ƿ�����"+colNum+"����¼������?")
			if(ifClear)
			{
	  			var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=CancelOper&opaId="+idStr;
	  			window.showModalDialog(lnk,"CancelOper","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=200,width=700,top=100,left=300");
			}
			else 
			{
				for(var j=0;j<=tmp.length;j++)
				{
					var index=tmp[j];
					record=obj.retGridPanelStore.getAt(index);
					record.set('checked','');
				}
				return; 
			}  
		}
	}
	obj.btnSch_click = function()
	{
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:200
			}
		});
	}

	obj.comAppLoc_select = function()
	{
		obj.loc.setValue(obj.comAppLoc.getValue());
	}

	obj.comAppLoc_keyup = function()
	{
		if(obj.comAppLoc.getRawValue()=="")
		obj.loc.setValue("");
	}
	

    obj.retGridPanel_rowdblclick=function()
	{
	    var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		var lnk= "ANInfo.csp?opaId="+opaId;
		showModalDialog(lnk,selectObj,"dialogWidth:1280px;dialogHeight:1024px;status:no;menubar:no;");
	}
	obj.OpEquipment_click=function()
	{
	    var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if(selectObj)
		{
		    var lnk= "AnOpEquipment.csp?opaId="+opaId;
		    showModalDialog(lnk,selectObj,"dialogWidth:700px;dialogHeight:500px;status:no;menubar:no;");
			}
	    else
		{
		   alert("��ѡ��һ��������¼��");
		}
	}
	obj.timebtn_click=function()
	{
	   var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if(selectObj)
		{
		    var lnk= "dhcantime.csp?opaId="+opaId;
		    showModalDialog(lnk,selectObj,"dialogWidth:400px;dialogHeight:200px;status:no;menubar:no;");
			}
	    else
		{
		   alert("��ѡ��һ��������¼��");
		}
	}
	obj.retGridPanel_rowclick=function() //������ȡ����
	{
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
	    {
			var adm=selectObj.get('adm');
			obj.EpisodeID.setValue(adm);
			var EpisodeID=adm;
			var AnaesthesiaID="";
			var PatientID=selectObj.get('PatientID');
			var mradm=selectObj.get('PAADMMainMRADMDR');
			AnaesthesiaID=selectObj.get('AnaesthesiaID');
			var win=top.frames['eprmenu'];
			var isSet=false;
			if (win) {
				var frm = win.document.forms['fEPRMENU'];
				if (frm) {
					frm.PatientID.value = PatientID;
					frm.EpisodeID.value =adm;
					frm.mradm.value=mradm;
					if(frm.AnaesthesiaID) frm.AnaesthesiaID.value =AnaesthesiaID;
					isSet=true;					
				}
			}
			if (isSet==false)
			{
				var frm =dhcsys_getmenuform();
				if (frm) 
				{
					frm.PatientID.value = PatientID;
					frm.EpisodeID.value =adm;
					frm.mradm.value=mradm;
					if(frm.AnaesthesiaID) frm.AnaesthesiaID.value =AnaesthesiaID;					
				}
			}	
		}
	}

	btnClearRoom_click=function()
	{
		var count=obj.retGridPanelStore.getCount();//��������
		var idStr="";
		var tmp=new Array();
		var colNum=new Array();
		var invNum=new Array();
		for (var i=0;i<count;i++)
		{
			var sel=""
			var record=obj.retGridPanelStore.getAt(i);
			sel=record.get('checked');
			var status=record.get('status');
			var opaId=record.get('opaId');
			if(sel==true)
			{
				if((status!='����')&&(status!='����'))
				{
					invNum[invNum.length]=i;
					continue;
				}
				tmp[tmp.length]=i;
				colNum[colNum.length]=i+1;
				if(idStr=="") idStr=opaId;
				else idStr=idStr+"^"+opaId;
			}
		}
		if(idStr=="")
		{
			alert("�빴ѡ״̬Ϊ������ŵ�������");
			for(var j=0;j<=invNum.length;j++)
			{
				var index=invNum[j];
				record=obj.retGridPanelStore.getAt(index);
				record.set('checked','');
			}
			return;
		} 
		else
		{
			var ifClear=confirm("�Ƿ���յ�"+colNum+"����¼��������")
			if(ifClear)
			{
				var ret=_DHCANOPArrange.ClearOpRoom(idStr);
				if(ret!='0')
				{
					ExtTool.alert("����",ret);
					obj.retGridPanelStore.reload();
				}
				else
				{
					for(var j=0;j<=tmp.length;j++)
					{
						var index=tmp[j];
						record=obj.retGridPanelStore.getAt(index);
						record.set('oproom','��');
						record.set('opordno','δ��');
						record.set('status','����');
						record.set('checked','');
					}
				}		
			}
			else 
			{
				for(var j=0;j<=tmp.length;j++)
				{
					var index=tmp[j];
					record=obj.retGridPanelStore.getAt(index);
					record.set('checked','');
				}
				return; 
			}  
		}
	}
	btnAnDocOrdered_click = function()
	{
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		var opaId=selectObj.get('opaId');
		var status=selectObj.get('status');
		if((status=="����")||(status=='�ܾ�')||(status=='����'))
		{
			ExtTool.alert("��ʾ","���Դ�״̬����������!");
			return false;
		}
		ret=_UDHCANOPArrange.UpdateAnaDoctorOrdered(opaId,'Y');
		if (ret!=0) alert(ret);	
		else
		{
			ExtTool.alert("��ʾ","�����ɹ���");
				obj.retGridPanelStore.reload();
		}
	}

	obj.chkSelAll_check=function()
	{
		var val = arguments[1]
		obj.retGridPanelStore.each(function(record){
			record.set('checked', val);
		});
	}

	btnDirAudit_click=function()
	{
		var count=obj.retGridPanelStore.getCount();//��������
		var idStr="";
		for (var i=0;i<count;i++)
		{
			var sel=""
			var record=obj.retGridPanelStore.getAt(i);
			sel=record.get('checked');
			var status=record.get('status');
			status=status.replace(" ","")
			var opaId=record.get('opaId');
			if((sel==true)&&(status==''))
			{
			 idStr=idStr+opaId+'^';
			}
		}
	    if(idStr=="")
	    {
			ExtTool.alert("��ʾ","�빴ѡ״̬Ϊ�յ�������");
			return;
	    } 
	    else
	   	{ 
			var groupId=session['LOGON.GROUPID'];  
			var ret=_DHCANOPArrange.SetAnOpDirAudit(idStr,groupId);
			if (ret!="0") alert(ret);
			else 
			{
				ExtTool.alert("��ʾ","��˳ɹ���");
				obj.retGridPanelStore.reload();
			}
		}
	}
	//�ж��Ƿ���Ա༭
	obj.retGridPanel_beforeedit=function(ev) 
	{
		var status=ev.record.data.status;
		if((status!='����')&&(status!='����'))
		{
			return false;
		}
		if((ev.field=='oproom')&&(status=='�ܾ�'))
		{
			ExtTool.alert("��ʾ","���ܰ���״̬Ϊ�ܾ�������!");
			return false;
		}
		var GROUPDESC=session['LOGON.GROUPDESC']
		if(GROUPDESC!='������ʿ')
		{
			return false;
		}
		if(ev.field=='opordno')
		{ 
			var value=ev.record.data.oproom;
		  	if(value=='��')
		    {
			    return false;
		    }
		    if((obj.gdOpRoomStore.find('oprId',value)==-1)&&(obj.gdOpRoomStore.find('oprDesc',value)==-1))
		    {  
				ExtTool.alert("��ʾ",value+"���ڱ������ң������°���������!");
				return false;
		    }
		}
	}

	obj.retGridPanel_validateedit=function(ev)
	{
	}

	obj.retGridPanel_afteredit=function(ev) //�޸Ŀ��Һ�̨��
	{
		var maxNo=obj.maxOrdNo.getValue();  //���̨�κ�gui��ordNoStore�е�n����һ��
		maxNo=parseInt(maxNo)
		var opaId=ev.record.data.opaId;
		var opDate=ev.record.get('opdatestr').split(' ')[0].trim();
		if(ev.field=='oproom')
		{
			var ordNo=ev.record.data.opordno;
			var oprCode=ev.value;
			var oprId=ev.value;
			var index = obj.gdOpRoomStore.find('oprId',oprId);
			if(index!=-1)
			{
				oprId=obj.gdOpRoomStore.getAt(index).data.oprId;
			}
			if(ev.value!="")
			{
				if(ev.originalValue!=ev.value)
				{
					if(oprId!="")
					{
						var ret=_DHCANOPArrange.UpdateOpRoomAndOrdNo(opaId,oprId,maxNo,opDate);
					}
				}
				if(!intReg.exec(ret)) 
				{
					ExtTool.alert("����",ret);
					obj.retGridPanelStore.reload();
				}
				else
				{
					ev.record.set('opordno',ret);
					ev.record.set('status','����');
				}  
			}
			else
			{
				var ret=_DHCANOPArrange.ClearOpRoom(opaId);
				if(ret!='0')
				{
					ExtTool.alert("����",ret);
					obj.retGridPanelStore.reload();
				}
				else
				{
					ev.record.set('oproom','��');
					ev.record.set('opordno','δ��');
					ev.record.set('status','����');
				}
			}
		}
		if(ev.field=='opordno')
		{
			var ordNo=ev.value;
			if(ordNo!="")
			{ 
				var ret=_DHCANOPArrange.UpdateOpaSeqNo(opaId,ordNo,opDate);
			}
			if(ret!='0') 
			{
				ExtTool.alert("����",ret);
				obj.retGridPanelStore.reload();
			}
			else
			{
				ev.record.set('status','����');
			}
		}
		//20120613+zt
		if(ev.field=='scrubnurse')
		{
			var idStr=ev.value;
			if(idStr=="")
			{
				var ifEmpty=confirm("�Ƿ���Ϊ��?")
				if(ifEmpty)
				{
					var ret=_DHCANOPArrange.UpdateAnArrForNurse(opDate,opaId,'','D');
					if(ret=="")
					{
						var ret1=_DHCANOPArrange.UpdateAllAnOpArr(opDate,opaId)
						if(ret1!="") alert(ret1) 
					
					}
					else alert(ret)	
				}
				else ev.record.set('scrubnurse',ev.originalValue);
			}
			else 
			{
				var ret=_DHCANOPArrange.UpdateAnArrForNurse(opDate,opaId,idStr,'D');
                 //�ر�ע��************���Ѳ�ػ�ʿʱ��'D'��Ϊ'T'
				if(ret=="")
				{
					var ret1=_DHCANOPArrange.UpdateAllAnOpArr(opDate,opaId)
					if(ret1!="") alert(ret1) 
					else
					{
						//alert("ϴ�ְ��ųɹ�")
					}
				}
				else alert(ret)
			}
		}
		if(ev.field=='circulnurse')
		{
			var idStr=ev.value;
			if(idStr=="")
			{
				var ifEmpty=confirm("�Ƿ���Ϊ��?")
				if(ifEmpty)
				{
					var ret=_DHCANOPArrange.UpdateAnArrForNurse(opDate,opaId,'','T');
					if(ret=="")
					{
						var ret1=_DHCANOPArrange.UpdateAllAnOpArr(opDate,opaId)
						if(ret1!="") alert(ret1) 
					}
					else alert(ret)	
				}
				else ev.record.set('circulnurse',ev.originalValue);
			}
			else 
			{
				var ret=_DHCANOPArrange.UpdateAnArrForNurse(opDate,opaId,idStr,'T');
                 //�ر�ע��************���Ѳ�ػ�ʿʱ��'D'��Ϊ'T'
				if(ret=="")
				{
					var ret1=_DHCANOPArrange.UpdateAllAnOpArr(opDate,opaId)
					if(ret1!="") alert(ret1) 
					else 
					{
						//alert("Ѳ�ذ��ųɹ�");
					}					
				}
				else alert(ret);
			}
		}
	}

	function AppNewOper(appType,lnk,nwin)	//pat doctor new application
	{
		var opaId="";
		var EpisodeID=obj.EpisodeID.getValue();
		lnk+="&opaId="+"&appType="+appType+"&EpisodeID="+EpisodeID;
		window.open(lnk,'_blank',nwin);
		//ADD MFC 2012-8-7����
		//var returnVal=window.showModalDialog(lnk,'_blank',nwin);
		obj.btnSch_click();
	}

	function ManageOper(appType,lnk,nwin)  
	{
		if(CheckNum()>1)
		{
			alert("ֻ��ѡ��һ������,������ѡ��");
			return;
		}

		if(CheckNum()>1)
		{
			alert("ֻ��ȡ��һ������,������ѡ��");
			return;
		}
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
		{
			var status=selectObj.get('status');
			if((appType=='ward')&&(status!='����')&&(status!=''))
			{
				ExtTool.alert("��ʾ","�ܲ���������״̬Ϊ: ���룬δ���")
				return;
			}      
			if((appType=='op')&&(status!='����')&&(status!='����'))
			{	     
				ExtTool.alert("��ʾ","�ܲ���������״̬Ϊ: ���룬����")
				return;
			}
			if((appType=='anaes')&&(status!='����')&&(status!='����'))
			{
				ExtTool.alert("��ʾ","�ܲ���������״̬Ϊ: ���룬����")
				return;
			}
			if((appType=='RegOp')&&(status!='����')&&(status!='����')&&(status!='���'))
			{
				ExtTool.alert("��ʾ","�ܲ���������״̬Ϊ: ���ţ����� �����")
				return;
			}
			var opaId=selectObj.get('opaId');
			//obj.opaId.setValue(opaId);
		}
		else 
		{
			ExtTool.alert("��ʾ","����ѡ��һ�У�");
			return;
		}
		if (opaId=="")
		{
			ExtTool.alert("��ʾ","����ѡ��һ�У�");
			return;
		}
		lnk+="&opaId="+opaId+"&appType="+appType;
		window.open(lnk,'_blank',nwin);
		//window.open(lnk,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,height=800,width=1100,top=10,left=30");
		//ADD MFC 2012-08-08����
		//var returnVal=window.showModalDialog(lnk,'_blank',nwin);
		obj.btnSch_click();
	}

	function ANOPCount(lnk,nwin)
	{

		var opaId="";
	    var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
	    if (selectObj)
		{
		    var status=selectObj.get('status');
			if((status!='����')&&(status!='����')&&(status!='����')&&(status!='�ָ���')&&(status!='���'))
			{
				ExtTool.alert("��ʾ","�ܲ���������״̬Ϊ: ���ţ����У����ϣ��ָ��ң����")
			    return;
			}
			var opaId=selectObj.get('opaId');
		}
	  	if (opaId=="")
	  	{
	   		ExtTool.alert("��ʾ","��ѡ��һ��������¼");
	   		return;
	  	}
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPCount"
		var nwin="toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,height=700,width=960,top=0,left=0"
	   	lnk+="&opaId="+opaId+"&EpisodeID="+EpisodeID;
	   	window.open(lnk,'_blank',nwin);	
	}

	AnAtOperation=function(Type)
	{
		if(CheckNum()>1)
		{
			alert("ֻ��ѡ��һ������,������ѡ��");
			return;
		}

		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
		{
			var status=selectObj.get('status');
			if ((status!='����')&&(status!='����')&&(status!='����')&&(status!='���'))
			{
				ExtTool.alert("��ʾ","�ܲ���������״̬Ϊ:"+"����"+","+"����"+","+"����"+","+"���");
				return;
			}
			var str="";
			var opaId="";
			opaId=selectObj.get('opaId');
			var connectStr=_DHCCLCom.GetConnectStr();
			var userCTLOCId=session['LOGON.CTLOCID'];
			var lnk="dhcanrecord.csp?opaId="+opaId+"&connectStr="+connectStr+"&isSuperUser="+false+"&userCTLOCId="+userCTLOCId+"&documentType="+Type;
			showModalDialog(lnk,"DHCAna","dialogWidth:1280px;dialogHeight:1024px;status:no;menubar:no;");
		}
		else
		{
			ExtTool.alert("��ʾ","��ѡ��һ��������¼");
		}
	}
	AnPdfDisplay=function()
	{
	 var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
		{
		    var status=selectObj.get('status');
			if ((status!='����')&&(status!='���')&&(status!='�ָ���'))
			{
				ExtTool.alert("��ʾ","�ܲ���������״̬Ϊ:"+"����"+","+"�ָ���"+","+"���");
				return;
			}
		    var str="";
			var opaId="";
			opaId=selectObj.get('opaId');
			var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANPdfDisplay"
			//var lnk= "../scripts/dhcclinic/an/showPDF.html"
			showModalDialog(lnk,"DHCANPdfDisplay","dialogWidth:1280px;dialogHeight:1024px;status:yes;menubar:no;");
			//window.open(lnk,"DHCANPdfDisplay","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=Yes,resizable=no,height=1024,width=1280,top=0,left=0");
			
		}
		else
		{
			ExtTool.alert("��ʾ","��ѡ��һ��������¼");
		}
	}
	function CheckNum()
	{
		SelectNum=0;
		for (var i=0;i<obj.retGridPanelStore.getCount();i++)
		{
			var record=obj.retGridPanelStore.getAt(i);
			sel=record.get('checked');
			if(sel==true)
			{
				SelectNum++;
			}
		}
		return SelectNum
	}
	function RefuseOper()
	{	
		var ifOuttime=_UDHCANOPArrange.GetIfOutTime();
	   	if(ifOuttime==1)
	   	{
		   	alert("ȡ������ʱ�䳬���涨ʱ��,����ȡ����������ϵ�����������Ա!");
		   	return;
		}
		if(CheckNum()>1)
		{
			alert("ֻ��ȡ��һ������,������ѡ��");
			return;
		}
	    var count=obj.retGridPanelStore.getCount();//��������
		var idStr="",invalCol="";
		var tmp=new Array();
		var colNum=new Array();
		var invNum=new Array();
		for (var i=0;i<count;i++)
		{
			var sel=""
			var record=obj.retGridPanelStore.getAt(i);
			sel=record.get('checked');
			var status=record.get('status');
			var opaId=record.get('opaId');
			if(sel==true)
			{
				var num=i+1;				
				if((status!='����')&&(status!='����')&&session['LOGON.GROUPDESC']=="������ʿ")
				{
					invNum[invNum.length]=i
					continue;
				}
				tmp[tmp.length]=i;
				colNum[colNum.length]=i+1;
				if(idStr=="") idStr=opaId;
				else idStr=idStr+"^"+opaId;
			}
		}
		if(idStr=="")
		{
				alert("��ѡ��״̬Ϊ������ŵ�������");
				for(var j=0;j<=invNum.length;j++)
				{
					var index=invNum[j];
					record=obj.retGridPanelStore.getAt(index);
					record.set('checked','');
				}
			return;
		} 
		else
		{
			if((status!='����')&&(session['LOGON.GROUPDESC']=="Inpatient Doctor"))
			{
				alert("��Ȩ�޶Դ�״̬����������")
				return;
			}
			var ifClear=confirm("�Ƿ�ܾ���"+colNum+"����¼������?")
			if(ifClear)
			{
	  			var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPSuspend&opaId="+idStr;
	  			window.showModalDialog(lnk,"UDHCANOPAppRetReason","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=200,width=700,top=100,left=300");
			}
			else 
			{
				for(var j=0;j<=tmp.length;j++)
				{
					var index=tmp[j];
					record=obj.retGridPanelStore.getAt(index);
					record.set('checked','');
				}
				return; 
			}  
		}
	}
	
	function CancelRefusedOper()
	{
		if(CheckNum()>1)
		{
			alert("ֻ��ѡ��һ������,������ѡ��");
			return;
		}
		var count=obj.retGridPanelStore.getCount();//��������
		var idStr=""
		var tmp=new Array();
		var colNum=new Array();
		var invNum=new Array();
		for (var i=0;i<count;i++)
		{
			var sel=""
			var record=obj.retGridPanelStore.getAt(i);
			sel=record.get('checked');
			var status=record.get('status');
			var opaId=record.get('opaId');
			if(sel==true)
			{
				if(status!='�ܾ�')
				{
					invNum[invNum.length]=i
					continue;
				}
				tmp[tmp.length]=i;
				colNum[colNum.length]=i+1;
				if(idStr=="") idStr=opaId;
				else idStr=idStr+"^"+opaId;
			}
		}
		if(idStr=="")
		{
			alert("��ѡ��״̬Ϊ�ܾ���������");
			for(var j=0;j<=invNum.length;j++)
			{
				var index=invNum[j];
				record=obj.retGridPanelStore.getAt(index);
				record.set('checked','');
			}
			return;
		} 
		else
		{
			var ret=_DHCANOPArrange.ChangeAnopStat("A",idStr);
			if(ret!=0)
			{
				ExtTool.alert("��ʾ",ret);
			}
			else 
			{
				ExtTool.alert("��ʾ","�ɹ�ȡ�������ܾ���");
				for(var j=0;j<=tmp.length;j++)
				{
					var index=tmp[j];
					record=obj.retGridPanelStore.getAt(index);
					record.set('status','����');
					record.set('checked','');
				}
			}
		}
	}

	btnOpRoomLimit_click=function()     //�������������ƣ��й�ҽ���ã����ܲ�ͨ��
	{  
		var ret=_UDHCANOPArrange.UPDataOpDirAuditStatus('Y')
		if (ret!=0) alert(ret);
	}
	btnOpRoomOpen_click=function()     //ȡ�����������ƣ��й�ҽ���ã����ܲ�ͨ��
	{ 
		var ret=_UDHCANOPArrange.UPDataOpDirAuditStatus('N')
		if (ret!=0) alert(ret);
	}

	function PrintAnOpList(prnType,exportFlag)
	{
		if (prnType=="") return;
		var name,fileName,path,operStat,printTitle,operNum;
		var xlsExcel,xlsBook,xlsSheet;
		var row=3;
		var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
		var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
		path=GetFilePath();
		printTitle=_UDHCANOPSET.GetPrintTitle(prnType);
		var printStr=printTitle.split("!");
		if (printTitle.length<4) return;
		name=printStr[0];	
		fileName=printStr[1];
		fileName=path+fileName;
		xlsExcel = new ActiveXObject("Excel.Application");
		xlsBook = xlsExcel.Workbooks.Add(fileName) ;
		xlsSheet = xlsBook.ActiveSheet;
		operStat=printStr[2];
		var strList=printStr[3].split("^")
		var printLen=strList.length;
		for (var i=0;i<printLen;i++)
		{
			xlsSheet.cells(row,i+1)=strList[i].split("|")[0];
		}
		var row=3;
		operNum=0;
		var preLoc="";
		var preRoom="";
		var count=obj.retGridPanelStore.getCount();//��������
		var selPrintTp=obj.chkSelPrint.getValue()?'S':'A';
		for (var i=0;i<count;i++)
		{
			var chk=""
			var record=obj.retGridPanelStore.getAt(i);
			chk=record.get('checked');
			var stat=record.get('status');
			if (((selPrintTp=="A")&&((stat==operStat)||(operStat=="")))||((selPrintTp=="S")&&(chk==true)))
			{
				row=row+1;
				operNum=operNum+1;
				//Sort by loc, insert empty row between different loc 
				var loc=record.get('loc');
				var locarr=loc.split("/");
				if (locarr.length>1) loc=locarr[0];
				var room=record.get('oproom');             //�й�ҽ���ã���ͬ�������䣬����һ�����У���ͷ������
				if ((preRoom!="")&&(preRoom!=room))
				{
					row=row+1;
					for (var n=0;n<printLen;n++)
					{
						xlsSheet.cells(row,n+1)=strList[n].split("|")[0];
					}
					row=row+1;
				}
				for(var j=0;j<printLen;j++)
				{
					var colName=strList[j].split("|")[1];
					var colVal=record.get(colName)
					if(colVal)
					{
						if ((colName=="oproom")||(colName=="opordno"))
						{
							if((colVal=='��')||(colVal=='δ��')) xlsSheet.cells(row,j+1)="";
							else xlsSheet.cells(row,j+1)=colVal
						}
						else if(colName=="opname")
						{
							var opName=colVal.split(';');
							var colValLen=colVal.length;
							var firstOpNameLen=opName[0].length;
							xlsSheet.cells(row,j+1).FormulaR1C1=colVal;
							xlsSheet.cells(row,j+1).Characters(1,firstOpNameLen).Font.Name="����";
							xlsSheet.cells(row,j+1).Characters(firstOpNameLen+2,colValLen-firstOpNameLen).Font.Italic=true;
						}
						else
						{	
							xlsSheet.cells(row,j+1)=colVal;
						}
					}
					else xlsSheet.cells(row,j+1)="";
				}
				preLoc=loc;
				preRoom=room;
			}
		}
		PrintTitle(xlsSheet,prnType,printStr,operNum);
		titleRows=3;
		titleCols=1;
		LeftHeader = " ",CenterHeader = " ",RightHeader = " ";LeftFooter = "";CenterFooter = "";RightFooter = " &N - &P ";
		ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter);
		AddGrid(xlsSheet,3,0,row,printLen-1,3,1);
		FrameGrid(xlsSheet,3,0,row,printLen-1,3,1);
		if (exportFlag=="N")
		{
			xlsExcel.Visible = true;
			xlsSheet.PrintPreview;
			//xlsSheet.PrintOut(); 
		}
		else
		{
			if (exportFlag=="Y")
			{
				var savefileName="C:\\Documents and Settings\\";
				var savefileName=_UDHCANOPSET.GetExportParth()
				var d = new Date();
				savefileName+=d.getYear()+"-"+(d.getMonth()+ 1)+"-"+d.getDate();
				savefileName+=" "+d.getHours()+","+d.getMinutes()+","+d.getSeconds();
				savefileName+=".xls"
				xlsSheet.SaveAs(savefileName);	
			}	
		}
		xlsSheet = null;
		xlsBook.Close(savechanges=false)
		xlsBook = null;
		xlsExcel.Quit();
		xlsExcel = null;
	}

	function PrintTitle(objSheet,prnType,printStr,operNum)
	{
		var sheetName=printStr[0];	
		var setList=printStr[3].split("^")
		var colnum=setList.length;
		var hospitalDesc=_DHCCLCom.GetHospital()
		mergcell(objSheet,1,1,colnum);
		xlcenter(objSheet,1,1,colnum);
		fontcell(objSheet,1,1,colnum,16);
		objSheet.cells(1,1)=hospitalDesc+sheetName;
		var operStartDate=obj.dateFrm.getRawValue();
		var tmpOperStartDate=operStartDate.split("/");
		if (tmpOperStartDate.length>2) operStartDate=tmpOperStartDate[2]+" �� "+tmpOperStartDate[1]+" �� "+tmpOperStartDate[0]+" ��";
		mergcell(objSheet,2,1,colnum);
		fontcell(objSheet,2,1,colnum,10);
		objSheet.cells(2,1)=operStartDate;
		if (prnType=="SSD") objSheet.cells(2,1)=operStartDate+"                    "+'����̨��:'+" "+operNum;
		if (prnType=="MZD") objSheet.cells(2,1)=operStartDate;
	}

	function GetFilePath()
	{
		var path=_DHCLCNUREXCUTE.GetPath();
		return path;
	}

	function GetComboxStoreDesc(value,store,descName,valueName)  
	{
		var index=store.find(valueName,value)
		store.load({});
		if(index!=-1)
		{
			return store.getAt(index).data[descName];
		}
		return value;
	}
	Ext.apply(Ext.form.VTypes,{
		lengthRange:function(val,field)
		{
			var minLength=0;
			var maxLength=10;
			if(field.lengthRange)
			{
				minLength=field.lengthRange.min;
				maxLength=field.lengthRange.max;		
			}
			if(val.length<minLength||val.length>maxLength)
			{
				if(minLength==0) field.vtypeText="������ĳ��ȱ���С��"+maxLength+"!";
				else field.vtypeText="������ĳ��ȱ�����"+minLength+"��"+maxLength+"֮��!";
				return false;
			}
			return true;
		}
		
		
	})
  
}




//////�༭�����еĴ��룺���ܻ��õ���ʱ��ɾ��

   /*if(ret>=2)                                        //��ע�Ͳ���Ϊ������ʼ��������Ҫ�任Ϊ��̨��ʱ�ã�Ŀǰ�й�ҽ��ʹ�á�
		 	  	{
		 	  		var value=ev.value;
		 	  		var oprDesc=""
		 	  		//var oprDesc=GetComboxStoreDesc(value,obj.gdOpRoomStore,'oprDesc','oprCode');
		 	  		var num=ret-1;
		 	  		ev.record.set('opdate','��̨'+num);
		 	  		if(obj.dateFrm.getRawValue()!=obj.dateTo.getRawValue())
		 	  		{
		 	  			ev.record.set('opdate',opDate+' '+oprDesc+'��̨'+num);
		 	  		}
		 	  	}
		 	  	else 
		 	  	{
		 	  		var value=ev.value;
		 	  		var oprDesc=""
		 	  		//var oprDesc=GetComboxStoreDesc(value,obj.gdOpRoomStore,'oprDesc','oprCode');
		 	  		ev.record.set('opdate','��̨');
		 	  		if(obj.dateFrm.getRawValue()!=obj.dateTo.getRawValue())
		 	  		{
		 	  			ev.record.set('opdate',opDate+' '+oprDesc+'��̨');
		 	  		}
		 	  	}*/

      /*var value=ev.record.data.oproom;                //ע�Ͳ���Ϊ������ʼ��������Ҫ�任Ϊ��̨��ʱ�ã�Ŀǰ�й�ҽ��ʹ�á�
		 	  	var oprDesc=GetComboxStoreDesc(value,obj.gdOpRoomStore,'oprDesc','oprCode');
		 	  	if(ordNo>=2) 
		 	  	{
		 	  		var num=ordNo-1;
		 	  		ev.record.set('opdate','��̨'+num);
		 	  		if(obj.dateFrm.getRawValue()!=obj.dateTo.getRawValue())
		 	  		{
		 	  			ev.record.set('opdate',opDate+' '+oprDesc+'��̨'+num);
		 	  		}
		 	  	}
		 	  	else 
		 	  	{
		 	  		ev.record.set('opdate','��̨');
		 	  		if(obj.dateFrm.getRawValue()!=obj.dateTo.getRawValue())
		 	  		{
		 	  			ev.record.set('opdate',opDate+' '+oprDesc+'��̨');
		 	  		}
		 	  	}*/


		/*if(ev.field=='oproom')
		 {
		 	 tmpArr=[];
		 	 var opRoom=ev.value;
		 	 var opDate=ev.record.data.opdatestr.split(' ')[0].trim();
		 	 var intReg=/^[1-9]\d*$/;
		 	 var count=obj.retGridPanelStore.getCount();//��������
		 	 var rowIndex=ev.row;
		 	 //var originalValue=ev.originalValue; 
		 	 for(var i=0;i<count;i++)
		 	 {
		 	 	 var record=obj.retGridPanelStore.getAt(i);
		 	 	 var ordNo_i=record.get('opordno');
		 	 	 var value_i=record.get('oproom');
		 	 	 var opRoom_i=GetComboxStoreValue(value_i,obj.gdOpRoomStore,'oprDesc','oprId');
		 	 	 var opDate_i=record.get('opdatestr').split(' ')[0].trim();
		 	 	 //alert(opRoom_i+"/"+opRoom+"/"+opDate_i+"/"+opDate)
		 	 	 if((opRoom_i==opRoom)&&(opDate_i==opDate)&&(i!=rowIndex)&&(intReg.exec(ordNo_i)))
		 	 	 {
		 	 	 	 for(j=0;j<maxNo;j++)
		 	 	 	 {
		 	 	 	 	 if(j==ordNo_i) tmpArr[j]=0;
		 	 	 	 	 else if(tmpArr[j]!=0) tmpArr[j]=j;	 	 	 
		 	 	 	 }
		 	   }
		 	  }
		 	 /*if(ordNo<=maxNo)
		 	 {
		 	 	var roomDesc=GetComboxStoreDesc(value,obj.gdOpRoomStore,'oprDesc','oprId');
		 	 	ExtTool.alert("��ʾ",opDate+","+roomDesc+"�Ѱ��ŵ���"+maxNo+"̨���ڵ�"+maxCol+"��,������ѡ��̨�Σ�");
			  return false;
		 	 }
		 }*/


 	  	/****************************************************************************
		 	 var value=ev.record.data.oproom.trim();
		 	 var opRoom=GetComboxStoreValue(value,obj.gdOpRoomStore,'oprDesc','oprId');
		 	 var opDate=ev.record.data.opdatestr.split(' ')[0].trim();
		 	 var intReg=/^[1-9]\d*$/;
		 	 var count=obj.retGridPanelStore.getCount();//��������
		 	 var ordNo=ev.value;
		 	 var rowIndex=ev.row;
		 	 var maxNo=1;
		 	 var originalValue=ev.originalValue; 
		 	 var changeOrdNo=ordNo
		 	 for(var i=rowIndex+1;i<count;i++)
		 	 {
		 	 	 var record=obj.retGridPanelStore.getAt(i);
		 	 	 var ordNo_i=record.get('opordno');
		 	 	 var value_i=record.get('oproom');
		 	 	 var opRoom_i=GetComboxStoreValue(value_i,obj.gdOpRoomStore,'oprDesc','oprId');
		 	 	 var opDate_i=record.get('opdatestr').split(' ')[0].trim();
		 	 	 if((opRoom_i==opRoom)&&(opDate_i==opDate))
		 	 	 {  alert(1);
		 	 	 	  changeOrdNo=changeOrdNo+1;
	          record.set('opordno',changeOrdNo);
		 	 	 }
		 	 	 }
		 	 	 *******************************************************************************/

 	 	  /*var min=maxNo-1;
		 	  if(tmpArr[min]==0) tmpArr[min]=maxNo-1;
		 	  if(tmpArr.length==0) minOrd=1;
		 	  else
		 	  {
		 	  for(i=maxNo-2;i>0;i--)
		 	  {
		 	  	if(tmpArr[i]==0) continue;
		 	  	if(tmpArr[min]>tmpArr[i]) min=i;
		 	  }
		 	  minOrd=tmpArr[min];
		 	 }*/
		 	 // var minOrd=_DHCANOPArrange.GetOpRoomOrder(opDate,roomId,opaId,maxNo)
		 	  //alert(minOrd)
       /* else 
		    {
		    	ExtTool.alert("��ʾ","���������޴�������!");        //���������Ҳ���idֵ�������Ϊ���ء��ޡ����緵����������������˵�����������޴������䡣
			    return false;
		    }
		    
		    function GetComboxStoreValue(value,store,descName,valueName)  
	     {
		     var index=store.find(descName,value)
		     store.load({});
		     if(index!=-1)
		    {
			    return store.getAt(index).data[valueName];
		    }
		    return value;
	      }    
		    
		    */