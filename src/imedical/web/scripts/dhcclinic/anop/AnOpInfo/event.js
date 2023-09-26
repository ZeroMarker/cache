

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
		//查询开始结束时间
		var ret=_DHCANOPCom.GetInitialDate(session['LOGON.USERID'],"",session['LOGON.CTLOCID']);
		obj.dateFrm.setValue(ret);
		obj.dateTo.setValue(ret);
		//20120531+dyl+麻醉科默认查询时间为当前日期与明天
		var GROUPDESC=session['LOGON.GROUPDESC'];
		if(GROUPDESC=='麻醉医生')
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
	    if ((ret!=1)&&(ret!=2))   //手术室:ret=1,麻醉科:ret=2
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
		obj.tb.doLayout();	//刷新工具栏
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
			case 'btnOpRoomLimit': //中国医大用
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
	//撤销手术
	function CancelOper()
	{	
		if(CheckNum()>1)
		{
			alert("只能撤销一条手术,请重新选择！");
			return;
		}
	    var count=obj.retGridPanelStore.getCount();//数据行数
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
				if((status!='申请')&&(status!='安排')&&session['LOGON.GROUPDESC']=="手术护士")
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
			alert("请选择状态为申请或安排的手术！");
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
				if(((status!='申请')&&(session['LOGON.GROUPDESC']=="Inpatient Doctor"))||((status!='申请')&&(session['LOGON.GROUPDESC']=="住院医生")))
				{
					alert("无权限对此状态的手术操作");
					return;
				}
			}
			var ifClear=confirm("是否撤销第"+colNum+"条记录的手术?")
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
		   alert("请选择一条手术记录！");
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
		   alert("请选择一条手术记录！");
		}
	}
	obj.retGridPanel_rowclick=function() //点击后获取数据
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
		var count=obj.retGridPanelStore.getCount();//数据行数
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
				if((status!='申请')&&(status!='安排'))
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
			alert("请勾选状态为申请或安排的手术！");
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
			var ifClear=confirm("是否清空第"+colNum+"条记录的手术间")
			if(ifClear)
			{
				var ret=_DHCANOPArrange.ClearOpRoom(idStr);
				if(ret!='0')
				{
					ExtTool.alert("警告",ret);
					obj.retGridPanelStore.reload();
				}
				else
				{
					for(var j=0;j<=tmp.length;j++)
					{
						var index=tmp[j];
						record=obj.retGridPanelStore.getAt(index);
						record.set('oproom','无');
						record.set('opordno','未排');
						record.set('status','申请');
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
		if((status=="申请")||(status=='拒绝')||(status=='撤销'))
		{
			ExtTool.alert("提示","不对此状态的手术操作!");
			return false;
		}
		ret=_UDHCANOPArrange.UpdateAnaDoctorOrdered(opaId,'Y');
		if (ret!=0) alert(ret);	
		else
		{
			ExtTool.alert("提示","操作成功！");
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
		var count=obj.retGridPanelStore.getCount();//数据行数
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
			ExtTool.alert("提示","请勾选状态为空的手术！");
			return;
	    } 
	    else
	   	{ 
			var groupId=session['LOGON.GROUPID'];  
			var ret=_DHCANOPArrange.SetAnOpDirAudit(idStr,groupId);
			if (ret!="0") alert(ret);
			else 
			{
				ExtTool.alert("提示","审核成功！");
				obj.retGridPanelStore.reload();
			}
		}
	}
	//判断是否可以编辑
	obj.retGridPanel_beforeedit=function(ev) 
	{
		var status=ev.record.data.status;
		if((status!='申请')&&(status!='安排'))
		{
			return false;
		}
		if((ev.field=='oproom')&&(status=='拒绝'))
		{
			ExtTool.alert("提示","不能安排状态为拒绝的手术!");
			return false;
		}
		var GROUPDESC=session['LOGON.GROUPDESC']
		if(GROUPDESC!='手术护士')
		{
			return false;
		}
		if(ev.field=='opordno')
		{ 
			var value=ev.record.data.oproom;
		  	if(value=='无')
		    {
			    return false;
		    }
		    if((obj.gdOpRoomStore.find('oprId',value)==-1)&&(obj.gdOpRoomStore.find('oprDesc',value)==-1))
		    {  
				ExtTool.alert("提示",value+"不在本手术室，请重新安排手术间!");
				return false;
		    }
		}
	}

	obj.retGridPanel_validateedit=function(ev)
	{
	}

	obj.retGridPanel_afteredit=function(ev) //修改科室和台次
	{
		var maxNo=obj.maxOrdNo.getValue();  //最大台次和gui中ordNoStore中的n保持一致
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
					ExtTool.alert("警告",ret);
					obj.retGridPanelStore.reload();
				}
				else
				{
					ev.record.set('opordno',ret);
					ev.record.set('status','安排');
				}  
			}
			else
			{
				var ret=_DHCANOPArrange.ClearOpRoom(opaId);
				if(ret!='0')
				{
					ExtTool.alert("警告",ret);
					obj.retGridPanelStore.reload();
				}
				else
				{
					ev.record.set('oproom','无');
					ev.record.set('opordno','未排');
					ev.record.set('status','申请');
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
				ExtTool.alert("警告",ret);
				obj.retGridPanelStore.reload();
			}
			else
			{
				ev.record.set('status','安排');
			}
		}
		//20120613+zt
		if(ev.field=='scrubnurse')
		{
			var idStr=ev.value;
			if(idStr=="")
			{
				var ifEmpty=confirm("是否安排为空?")
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
                 //特别注意************添加巡回护士时，'D'换为'T'
				if(ret=="")
				{
					var ret1=_DHCANOPArrange.UpdateAllAnOpArr(opDate,opaId)
					if(ret1!="") alert(ret1) 
					else
					{
						//alert("洗手安排成功")
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
				var ifEmpty=confirm("是否安排为空?")
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
                 //特别注意************添加巡回护士时，'D'换为'T'
				if(ret=="")
				{
					var ret1=_DHCANOPArrange.UpdateAllAnOpArr(opDate,opaId)
					if(ret1!="") alert(ret1) 
					else 
					{
						//alert("巡回安排成功");
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
		//ADD MFC 2012-8-7屏蔽
		//var returnVal=window.showModalDialog(lnk,'_blank',nwin);
		obj.btnSch_click();
	}

	function ManageOper(appType,lnk,nwin)  
	{
		if(CheckNum()>1)
		{
			alert("只能选择一条手术,请重新选择！");
			return;
		}

		if(CheckNum()>1)
		{
			alert("只能取消一条手术,请重新选择！");
			return;
		}
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
		{
			var status=selectObj.get('status');
			if((appType=='ward')&&(status!='申请')&&(status!=''))
			{
				ExtTool.alert("提示","能操作的手术状态为: 申请，未审核")
				return;
			}      
			if((appType=='op')&&(status!='申请')&&(status!='安排'))
			{	     
				ExtTool.alert("提示","能操作的手术状态为: 申请，安排")
				return;
			}
			if((appType=='anaes')&&(status!='申请')&&(status!='安排'))
			{
				ExtTool.alert("提示","能操作的手术状态为: 申请，安排")
				return;
			}
			if((appType=='RegOp')&&(status!='安排')&&(status!='术毕')&&(status!='完成'))
			{
				ExtTool.alert("提示","能操作的手术状态为: 安排，术毕 ，完成")
				return;
			}
			var opaId=selectObj.get('opaId');
			//obj.opaId.setValue(opaId);
		}
		else 
		{
			ExtTool.alert("提示","请先选中一行！");
			return;
		}
		if (opaId=="")
		{
			ExtTool.alert("提示","请先选中一行！");
			return;
		}
		lnk+="&opaId="+opaId+"&appType="+appType;
		window.open(lnk,'_blank',nwin);
		//window.open(lnk,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,height=800,width=1100,top=10,left=30");
		//ADD MFC 2012-08-08屏蔽
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
			if((status!='安排')&&(status!='术中')&&(status!='术毕')&&(status!='恢复室')&&(status!='完成'))
			{
				ExtTool.alert("提示","能操作的手术状态为: 安排，术中，术毕，恢复室，完成")
			    return;
			}
			var opaId=selectObj.get('opaId');
		}
	  	if (opaId=="")
	  	{
	   		ExtTool.alert("提示","请选择一条手术记录");
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
			alert("只能选择一条手术,请重新选择！");
			return;
		}

		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
		{
			var status=selectObj.get('status');
			if ((status!='安排')&&(status!='术毕')&&(status!='术中')&&(status!='完成'))
			{
				ExtTool.alert("提示","能操作的手术状态为:"+"安排"+","+"术中"+","+"术毕"+","+"完成");
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
			ExtTool.alert("提示","请选择一条手术记录");
		}
	}
	AnPdfDisplay=function()
	{
	 var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
		{
		    var status=selectObj.get('status');
			if ((status!='术毕')&&(status!='完成')&&(status!='恢复室'))
			{
				ExtTool.alert("提示","能操作的手术状态为:"+"术毕"+","+"恢复室"+","+"完成");
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
			ExtTool.alert("提示","请选择一条手术记录");
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
		   	alert("取消手术时间超过规定时间,如需取消手术请联系手术室相关人员!");
		   	return;
		}
		if(CheckNum()>1)
		{
			alert("只能取消一条手术,请重新选择！");
			return;
		}
	    var count=obj.retGridPanelStore.getCount();//数据行数
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
				if((status!='申请')&&(status!='安排')&&session['LOGON.GROUPDESC']=="手术护士")
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
				alert("请选择状态为申请或安排的手术！");
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
			if((status!='申请')&&(session['LOGON.GROUPDESC']=="Inpatient Doctor"))
			{
				alert("无权限对此状态的手术操作")
				return;
			}
			var ifClear=confirm("是否拒绝第"+colNum+"条记录的手术?")
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
			alert("只能选择一条手术,请重新选择！");
			return;
		}
		var count=obj.retGridPanelStore.getCount();//数据行数
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
				if(status!='拒绝')
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
			alert("请选择状态为拒绝的手术！");
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
				ExtTool.alert("提示",ret);
			}
			else 
			{
				ExtTool.alert("提示","成功取消手术拒绝！");
				for(var j=0;j<=tmp.length;j++)
				{
					var index=tmp[j];
					record=obj.retGridPanelStore.getAt(index);
					record.set('status','申请');
					record.set('checked','');
				}
			}
		}
	}

	btnOpRoomLimit_click=function()     //激活手术间限制，中国医大用，可能不通用
	{  
		var ret=_UDHCANOPArrange.UPDataOpDirAuditStatus('Y')
		if (ret!=0) alert(ret);
	}
	btnOpRoomOpen_click=function()     //取消手术间限制，中国医大用，可能不通用
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
		var count=obj.retGridPanelStore.getCount();//数据行数
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
				var room=record.get('oproom');             //中国医大用，不同的手术间，插入一条空行，表头重新起。
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
							if((colVal=='无')||(colVal=='未排')) xlsSheet.cells(row,j+1)="";
							else xlsSheet.cells(row,j+1)=colVal
						}
						else if(colName=="opname")
						{
							var opName=colVal.split(';');
							var colValLen=colVal.length;
							var firstOpNameLen=opName[0].length;
							xlsSheet.cells(row,j+1).FormulaR1C1=colVal;
							xlsSheet.cells(row,j+1).Characters(1,firstOpNameLen).Font.Name="宋体";
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
		if (tmpOperStartDate.length>2) operStartDate=tmpOperStartDate[2]+" 年 "+tmpOperStartDate[1]+" 月 "+tmpOperStartDate[0]+" 日";
		mergcell(objSheet,2,1,colnum);
		fontcell(objSheet,2,1,colnum,10);
		objSheet.cells(2,1)=operStartDate;
		if (prnType=="SSD") objSheet.cells(2,1)=operStartDate+"                    "+'手术台数:'+" "+operNum;
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
				if(minLength==0) field.vtypeText="您输入的长度必须小于"+maxLength+"!";
				else field.vtypeText="您输入的长度必须在"+minLength+"到"+maxLength+"之间!";
				return false;
			}
			return true;
		}
		
		
	})
  
}




//////编辑过程中的代码：可能会用掉暂时不删掉

   /*if(ret>=2)                                        //此注释部分为手术开始日期那需要变换为接台几时用，目前中国医大不使用。
		 	  	{
		 	  		var value=ev.value;
		 	  		var oprDesc=""
		 	  		//var oprDesc=GetComboxStoreDesc(value,obj.gdOpRoomStore,'oprDesc','oprCode');
		 	  		var num=ret-1;
		 	  		ev.record.set('opdate','接台'+num);
		 	  		if(obj.dateFrm.getRawValue()!=obj.dateTo.getRawValue())
		 	  		{
		 	  			ev.record.set('opdate',opDate+' '+oprDesc+'接台'+num);
		 	  		}
		 	  	}
		 	  	else 
		 	  	{
		 	  		var value=ev.value;
		 	  		var oprDesc=""
		 	  		//var oprDesc=GetComboxStoreDesc(value,obj.gdOpRoomStore,'oprDesc','oprCode');
		 	  		ev.record.set('opdate','首台');
		 	  		if(obj.dateFrm.getRawValue()!=obj.dateTo.getRawValue())
		 	  		{
		 	  			ev.record.set('opdate',opDate+' '+oprDesc+'首台');
		 	  		}
		 	  	}*/

      /*var value=ev.record.data.oproom;                //注释部分为手术开始日期那需要变换为接台几时用，目前中国医大不使用。
		 	  	var oprDesc=GetComboxStoreDesc(value,obj.gdOpRoomStore,'oprDesc','oprCode');
		 	  	if(ordNo>=2) 
		 	  	{
		 	  		var num=ordNo-1;
		 	  		ev.record.set('opdate','接台'+num);
		 	  		if(obj.dateFrm.getRawValue()!=obj.dateTo.getRawValue())
		 	  		{
		 	  			ev.record.set('opdate',opDate+' '+oprDesc+'接台'+num);
		 	  		}
		 	  	}
		 	  	else 
		 	  	{
		 	  		ev.record.set('opdate','首台');
		 	  		if(obj.dateFrm.getRawValue()!=obj.dateTo.getRawValue())
		 	  		{
		 	  			ev.record.set('opdate',opDate+' '+oprDesc+'首台');
		 	  		}
		 	  	}*/


		/*if(ev.field=='oproom')
		 {
		 	 tmpArr=[];
		 	 var opRoom=ev.value;
		 	 var opDate=ev.record.data.opdatestr.split(' ')[0].trim();
		 	 var intReg=/^[1-9]\d*$/;
		 	 var count=obj.retGridPanelStore.getCount();//数据行数
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
		 	 	ExtTool.alert("提示",opDate+","+roomDesc+"已安排到第"+maxNo+"台次在第"+maxCol+"行,请重新选择台次！");
			  return false;
		 	 }
		 }*/


 	  	/****************************************************************************
		 	 var value=ev.record.data.oproom.trim();
		 	 var opRoom=GetComboxStoreValue(value,obj.gdOpRoomStore,'oprDesc','oprId');
		 	 var opDate=ev.record.data.opdatestr.split(' ')[0].trim();
		 	 var intReg=/^[1-9]\d*$/;
		 	 var count=obj.retGridPanelStore.getCount();//数据行数
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
		    	ExtTool.alert("提示","本手术室无此手术间!");        //根据描述找不到id值正常情况为返回“无”，如返回手术间描述，则说明此手术室无此手术间。
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