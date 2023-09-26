

function InitViewScreenEvent(obj)
{ 
	var _DHCANOPCom=ExtTool.StaticServerObject('web.DHCANOPCom');	
	var _UDHCANOPArrange=ExtTool.StaticServerObject('web.UDHCANOPArrange');
	var _UDHCANOPSET=ExtTool.StaticServerObject('web.UDHCANOPSET');
	var _DHCClinicCom=ExtTool.StaticServerObject('web.DHCClinicCom');
	var _DHCANOPArrange=ExtTool.StaticServerObject('web.DHCANOPArrange');
	var intReg=/^[1-9]\d*$/;
	var SelectNum=0;
	var logLocType = "App"
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
			if (frm) { 				
			var EpisodeID=frm.EpisodeID.value; 
				var PatientID=frm.PatientID.value; 
				var mradm=frm.mradm.value; 
					}
		}
		obj.EpisodeID.setValue(EpisodeID)
		var userId=session['LOGON.USERID'];
		//��ѯ��ʼ����ʱ��
		var ret=_DHCANOPCom.GetInitialDate(session['LOGON.USERID'],"",session['LOGON.CTLOCID']);
		obj.dateFrm.setValue(ret);
		obj.dateTo.setValue(ret);
		try
		{
			var ipset=new ActiveXObject("rcbdyctl.Setting"); 
			var localIPAddress="";
			localIPAddress=ipset.GetIPAddress;
			//alert(localIPAddress)
			var retRoomStr=_DHCANOPCom.GetRoomIdByIp(localIPAddress);
			//alert(retRoomStr)
			if(retRoomStr!="")
			{
				obj.comOpRoom.setRawValue(retRoomStr.split("^")[1]);
			    obj.forComOpRoom.setValue(retRoomStr.split("^")[0])		
			}
		}
	    catch(e){}
	    var loc="^".split("^");
	    var ret=_UDHCANOPArrange.GetDocLoc(userId,session['LOGON.CTLOCID'])
	    if (ret!="")
	    {
			loc=ret.split("^");
            obj.comAppLoc.setValue(loc[1]);
			obj.loc.setValue(loc[1]);       
	    }  

	    if(obj.comAppLoc.getRawValue()=="") obj.loc.setValue("");

	    var userType="";
	    userType=_DHCANOPCom.GetUserType(userId);
	    var logUserType=""; //lonon user type: ANDOCTOR,ANNURSE,OPNURSE
	    var sessLoc=session['LOGON.CTLOCID'];
	    obj.userLocId.setValue(sessLoc);
	    var ret=_UDHCANOPSET.ifloc(sessLoc);
	    //alert(ret)
	    if ((ret!=1)&&(ret!=2))   //������:ret=1,�����:ret=2
	    {
			//alert(ret)
			//ward nurse:link location's operatoin apply
			//ward doctor: logon location's operatoin apply
			//alert(loc)
			obj.comAppLoc.setValue(loc[1]);
			Ext.getDom("comAppLoc").value=loc[0];			
			obj.loc.setValue(loc[1]);
			if (userType=="NURSE") 
			{
				if(obj.comAppLoc.getRawValue()=="")
				{
					var ret=_DHCClinicCom.GetLinkLocId(sessLoc)
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
		var buttonStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
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
	                 if (records[i].data.name == "btnOpRoomLimit") {
						var opDirAuditStatus = _DHCANOPArrange.GetOpDirAuditStatus()
							if ((opDirAuditStatus == "N") || (opDirAuditStatus == "")) {
								btn.setText("�����俪��")
							}
							if (opDirAuditStatus == "Y") {
								btn.setText("����������")
							}
					}					
					obj.tb.addButton(btn);					
				}
             obj.tb.doLayout();
			}
		})	

		
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
			[ 
			   {name: 'name', mapping: 'name'}
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
				obj.opManageMenu.doLayout();
			}
	   	})
		
		obj.logUserType.setValue(logUserType);
		obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.UDHCANOPArrange';
			param.QueryName = 'GetAnOpList';
			param.Arg1 = obj.dateFrm.getRawValue();
			param.Arg2 = obj.dateTo.getRawValue();
			param.Arg3 = obj.comOperStat.getValue();
			param.Arg4 = obj.forComOpRoom.getValue();
			param.Arg5 = obj.loc.getValue();
			param.Arg6 = '';
			param.Arg7 = obj.userLocId.getValue();
			param.Arg8 = obj.chkIsAppT.getValue()?'1':'0';
			param.Arg9 = obj.txtMedCareNo.getValue();
			param.Arg10 = obj.comOprFloor.getValue();
			param.Arg11 = obj.PatWard.getValue();
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
	};
	OnButtonClick = function()
	{	
		switch(arguments[0].id)
		{
			case 'btnClearRoom':
				btnClearRoom_click();
				break;
			case 'btnOpRoomLimit': //�й�ҽ����
				btnOpRoomLimit_click();
				break;
			case 'btnOpRoomOpen': //�й�ҽ����
				btnOpRoomOpen_click();
				break;
			case 'btnDirAudit':
				btnDirAudit_click();
				break;
			case 'btnAnDocOrdered':
				btnAnDocOrdered_click();
			   break;
            case 'btnInRoom':
		    btnInRoom_click();
			break;
		   case 'btnLeave':
		    btnLeave_click();
			break;
		   case 'btnCancelOper': //ȡ����������ͬ��ȡ���ܾ�����
		    btnCancelOper_click();
	       break;
			default:
			break;
		}
	}
	OnMenuClick = function()
	{
	  	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=UDHCANOPAPP"
		var nwin="toolbar=no;location:no;directories:no;status:no;menubar:no;scrollbars:yes;resizable:no;dialogHeight:700px;dialogWidth:960px;top:0;left:0"
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
				AnAtOperation("AN");
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
            case "AdverseEvent":
	            DHCCLMSAN();
			   break;
			    default:
			    break;
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
	obj.comOpRoom_select=function()
	{
	 obj.forComOpRoom.setValue(obj.comOpRoom.getValue());
	}
	obj.comOpRoom_keyup=function()
	{
	 if(obj.comOpRoom.getRawValue()=="")
	 obj.forComOpRoom.setValue("");
	}
	obj.comPatWard_keyup=function()
	{
	 if(obj.comPatWard.getRawValue()=="")
	 obj.PatWard.setValue("");
	}	
	obj.comPatWard_select=function()
	{
	 obj.PatWard.setValue(obj.comPatWard.getValue());
	}
/*	ȥ���������Զ����Ĺ��� modify by whl 20120514
obj.txtMedCareNo_keyup=function()
	{
		var digitReg=/^[0-9]\d*$/;
		var value=obj.txtMedCareNo.getValue();
		var n=obj.txtMedCareNo.lengthRange.max
		if(digitReg.exec(value))
		{
			var str0=""
			var len=value.length;
			if(value.substr(0,1)!=0) 
			{ 
				for(i=1;i<n-len+1;i++)
				{
					str0=str0+'0'
				}
				value=str0+value;
				if(value.length==n) obj.txtMedCareNo.setValue(value);
			}
			else
			{
				var sn=len-n;
				if(sn>=0)
				{
					value=value.substr(sn);
					if(value.length==n)
					obj.txtMedCareNo.setValue(value);
				}
				else 
				{ 
					var cn=n-len;
					for(j=1;j<cn+1;j++)
					{
						str0=str0+'0';
					}
					value=str0+value;
					if(value.length==n) obj.txtMedCareNo.setValue(value);
				}
			}
		}	
	}
	*/
	/*obj.date_blur=function IsValidDate(e)
	{
		var dt=e.value;
		var re = /^(\s)+/ ; dt=dt.replace(re,'');
		var re = /(\s)+$/ ; dt=dt.replace(re,'');
		var re = /(\s){2,}/g ; dt=dt.replace(re,' ');
		if (dt=='') {e.value=''; return 1;}
		re = /[^0-9A-Za-z]/g ;
		dt=dt.replace(re,'/');
		for (var i=0;i<dt.length;i++) {
			var type=dt.substring(i,i+1).toUpperCase();
			if (type=='T'||type=='W'||type=='M'||type=='Y') {
				if (type=='T') {return ConvertTDate(e);} else {return ConvertWMYDate(e,i,type);}
				break;
			}
		}
		if ((dt.indexOf('/')==-1)&&(dt.length>2)) dt=ConvertNoDelimDate(dt);
		var dtArr=dt.split('/');
		var len=dtArr.length;
		if (len>3) return 0;
		for (i=0; i<len; i++) {
			if (dtArr[i]=='') return 0;
		}
		var dy,mo,yr;
		for (i=len; i<3; i++) dtArr[i]='';
		dy=dtArr[0];mo=dtArr[1];yr=dtArr[2];
		if ((String(yr).length!=2)&&(String(yr).length!=4)&&(String(yr).length!=0)) return 0;
		if ((String(yr).length==4)&&(yr<1840)) return 0;
		var today=new Date();
		if (yr=='') {
			yr=today.getYear();
			if (mo=='') mo=today.getMonth()+1;
		}
		if ((isNaN(dy))||(isNaN(mo))||(isNaN(yr))) return 0;
		if ((dy<1)||(dy>31)||(mo<1)||(mo>12)||(yr<0)) return 0;
		if (mo==2) {
			if (dy>29) return 0;
			if ((!isLeapYear(yr))&&(dy>28)) return 0;
		}
		if (((mo==4)||(mo==6)||(mo==9)||(mo==11))&&(dy>30)) return 0;
		if (isMaxedDate(dy,mo,yr)) return 0;
		e.value=ReWriteDate(dy,mo,yr);
		websys_returnEvent();
		return 1;
	}*/
function ReWriteDate(d,m,y) {
	y=parseInt(y,10);
	if (y<15) y+=2000; else if (y<100) y+=1900;
	if ((y>99)&&(y<1000)) y+=1900;
	if ((d<10)&&(String(d).length<2)) d='0'+d;
	if ((m<10)&&(String(m).length<2)) m='0'+m;
	var newdate='';
	newdate=d+'/'+m+'/'+y;
	return newdate;
}
obj.retGridPanel_rowclick = function () {
		var count=obj.csm.getCount();  //20130423
		var selectObj = obj.csm.getSelected();
		if ((count==1)&&(selectObj)){
			var adm = selectObj.get('adm');
		
			obj.EpisodeID.setValue(adm);
			var EpisodeID = adm;
			var AnaesthesiaID = "";
						var PatientID=selectObj.get('PatientID');
			var mradm=selectObj.get('PAADMMainMRADMDR');

			AnaesthesiaID = selectObj.get('AnaesthesiaID');
			var win = top.frames['eprmenu'];
			var isSet = false;
			if (win) {
				var frm = win.document.forms['fEPRMENU'];
				if (frm) {
					frm.PatientID.value = PatientID;
					frm.EpisodeID.value =adm;
					frm.mradm.value=mradm;
					if (frm.AnaesthesiaID)
						frm.AnaesthesiaID.value = AnaesthesiaID;
					isSet = true;
				}
			}
			if (isSet == false) {
				var frm = dhcsys_getmenuform();
				if (frm) {
					frm.PatientID.value = PatientID;
					frm.EpisodeID.value =adm;
					frm.mradm.value=mradm;
					if (frm.AnaesthesiaID)
						frm.AnaesthesiaID.value = AnaesthesiaID;
				}
			}
		}
	}

   btnClearRoom_click = function () {
		var idStr = "";
		var tmp = new Array();
		var colNum = new Array();
		var records=obj.csm.getSelections();
		for(var i=0;i<records.length;i++) {
			var record=records[i];
			var rowIndex=obj.retGridPanelStore.indexOf(record)
			var status = record.get('status');
			status = status.replace(" ", "")
			var opaId = record.get('opaId');
			if ((status != '����') && (status != '����')) {
					obj.csm.deselectRow(rowIndex)
					continue;
				}
				tmp[tmp.length] = rowIndex;
				colNum[colNum.length] = rowIndex + 1;
				if (idStr == "")
				idStr = opaId;
				else
					idStr = idStr + "^" + opaId;
			}
		if (idStr == "") {
			alert("�빴ѡ״̬Ϊ������ŵ�������");
			return;
			}
		 else {
			var ifClear = confirm("�Ƿ���յ�" + colNum + "����¼��������")
				if (ifClear) {
					var ret = _DHCANOPArrange.ClearOpRoom(idStr);
					if (ret != '0') {
						alert(ret);
						obj.retGridPanelStore.reload();
					} else {
						for (var j = 0; j <= tmp.length; j++) {
							var index = tmp[j];
							record = obj.retGridPanelStore.getAt(index);
							record.set('oproom', '��');
							record.set('opordno', 'δ��');
							record.set('status', '����');
							obj.csm.deselectRow(index);
						}
					}
				} else {
					for (var j = 0; j <= tmp.length; j++) {
						var index = tmp[j];
						record = obj.retGridPanelStore.getAt(index);
						obj.csm.deselectRow(index);
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
		if((status=="����")||(status=='�ܾ�'))
		{
			alert("���Դ�״̬����������!");
			return false;
		}
		ret=_UDHCANOPArrange.UpdateAnaDoctorOrdered(opaId,'Y');
		if (ret!=0) alert(ret);	
		else
		{
			alert("�����ɹ���");
			selectObj.set("anaDoctorOrd","Y")
			//obj.retGridPanelStore.reload();
		}
	}

  obj.chkSelAll_check = function () {
		var val = arguments[1]
		if(val==true)
		obj.csm.selectAll() 
		else 
		obj.csm.clearSelections() 
	}
  btnDirAudit_click = function () {
		var idStr="";
		var tmp=new Array();
		var colNum=new Array();
	    var records=obj.csm.getSelections();
		for(var i=0;i<records.length;i++)
		{
		   var record=records[i];
		   var rowIndex=obj.retGridPanelStore.indexOf(record)
		   var status=record.get('status');
			 status = status.replace(" ", "")
			 var opaId = record.get('opaId');
			 if(status!='')
			 {
			  obj.csm.deselectRow(rowIndex) //20130423
			  continue;
			 }
				idStr = idStr + opaId + '^';
			}
		 if (idStr == "") {
			alert("�빴ѡ״̬Ϊ�յ�������");
			return;
		} else {
			var groupId = session['LOGON.GROUPID'];
			var ret = _DHCANOPArrange.SetAnOpDirAudit(idStr, groupId);
			if (ret != "0")
				alert(ret);
			else {
				alert("��˳ɹ���");
				obj.retGridPanelStore.reload();
			}
		}		
	}
	btnInRoom_click=function()
	{
     	var idStr = "";
		var tmp = new Array();
		var records=obj.csm.getSelections();
		for(var i=0;i<records.length;i++){
			var record=records[i];
			var rowIndex=obj.retGridPanelStore.indexOf(record)
			var status = record.get('status');
			status = status.replace(" ", "")
			var opRoom=record.get('oproom')
			var oprId=""
			var index = obj.gdOpRoomStore.find('oprDesc', opRoom);
			if (index != -1) {
				oprId = obj.gdOpRoomStore.getAt(index).data.oprId;
			}
			var opaId = record.get('opaId');
			if ((status == '����')&&(oprId!='')) {
			var ret0=_DHCANOPArrange.GetEditStat(opaId,oprId)
		  if(ret0!="1") 
			{
			 alert(ret0)
			 //obj.csm.deselectRow(rowIndex); 
			}
			else
			{
			 tmp[tmp.length] = rowIndex; 
			 idStr = idStr + opaId + '^';
			}
			}
		}
	  if(idStr!="")
	   {    
	    var ret1=_DHCANOPArrange.ChangeAnopStat("I",idStr)
		  if(ret1!="0") alert(ret1)
		  else 
		  {
		   alert("���³ɹ���")
		   for (var j = 0; j <= tmp.length; j++) {
			 var tmpIndex = tmp[j];
			 record = obj.retGridPanelStore.getAt(tmpIndex);
			 record.set('status', '����');
			 obj.csm.deselectRow(tmpIndex); 
					}
			}
		}
		else 
		{ 
		  obj.csm.clearSelections();
		}
	}
	btnLeave_click=function ()
	{
	  var idStr = "";
		var tmp = new Array();
		var records=obj.csm.getSelections();
		for(var i=0;i<records.length;i++){
		  var record=records[i];
			var rowIndex=obj.retGridPanelStore.indexOf(record)
		  var status = record.get('status');
		  status = status.replace(" ", "")
		  var opaId = record.get('opaId');

		  if (status == '����')
		  {
		   tmp[tmp.length] = rowIndex;
		   idStr = idStr + opaId + '^';
		  }
		  else
		  {
		   alert("��ѡ��״̬Ϊ���е�������")
		   //obj.csm.deselectRow(rowIndex);
		  }
		}
		if(idStr!="")
		{
		 var ret=_DHCANOPArrange.ChangeAnopStat("L",idStr)
		 if(ret!="0") alert(ret)
		 else 
		 {
		   alert("���³ɹ���")
		   for (var j = 0; j <= tmp.length; j++) {
		   var tmpIndex = tmp[j];
		   var record = obj.retGridPanelStore.getAt(tmpIndex);
		   record.set('status', '����');
		   obj.csm.deselectRow(tmpIndex);
					}
		  }
		}
		else obj.csm.clearSelections();
	}
	//�ж��Ƿ���Ա༭
	obj.retGridPanel_beforeedit = function (ev) {
	    if((ev.field=='oproom')||(ev.field=='opordno')||(ev.field=='tNurseNote')||(ev.field=='scrubnurse')||(ev.field=='circulnurse'))
		{
		 if(logLocType!="OP") return false;
		}
		if(ev.field=='andoc')
		{
		 if(logLocType!="AN") return false;
		}
		var groupId=session['LOGON.GROUPID'];
		var flag=false;
		var retStr=_DHCANOPArrange.getEditColumn(groupId);
		for(i=0;i<retStr.split("^").length;i++)
		{
		 var column=retStr.split("^")[i];
		 if(ev.field==column)
		 {
		  flag=true
		 }
		}
		if(!flag) return false;
		var status = ev.record.data.status;
		if ((status != '����') && (status != '����')) {
			alert("ֻ�ܰ���״̬Ϊ������ŵ�����!");
			return false;
		}
      if (ev.field == 'opordno') {
			var value = ev.record.data.oproom;
			if (value == '��') {
				alert("�����Ȱ���������!");
				return false;
			}
		    if((obj.gdOpRoomStore.find('oprId',value)==-1)&&(obj.gdOpRoomStore.find('oprDesc',value)==-1))
		    {  
				alert(value+"���ڱ������ң������°���������!");
				return false;
		    }
		}
		if(ev.field=='scrubnurse')   //lov
		{
			if(status!='����') 
			{ 
				alert("���Ȱ�������!");
				return false;
			}
		}
		if(ev.field=='circulnurse')   //lov
		{
			if(status!='����') 
			{ 
				alert("���Ȱ�������!");
				return false;
			}
			//if((logLocType=="App")||(logLocType=="AN"))
			//{return false;}
		}
	}

	obj.retGridPanel_validateedit=function(ev)
	{
	}
 obj.retGridPanel_afteredit=function(ev) //�޸Ŀ��Һ�̨��
	{
		var maxNo=obj.maxOrdNo.getValue();  //���̨�κ�gui��ordNoStore�е�n����һ��
		//alert(maxNo);
		maxNo=parseInt(maxNo)
		var opaId=ev.record.data.opaId;
		var opDate=ev.record.get('opdatestr').split(' ')[0].trim();
		//alert(opDate)
		if(ev.field=='oproom')
		{
			var ordNo=ev.record.data.opordno;
			var oprCode=ev.value;
			var oprId=ev.value;
			var index = obj.gdOpRoomStore.find('oprId',oprId);
			//obj.gdOpRoomStore.load({});
			if(index!=-1)
			{
				oprId=obj.gdOpRoomStore.getAt(index).data.oprId;
			}
			else {
				alert("�޴�������,������ѡ��,�����������������Ч!");
				return false;
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
					alert(ret);
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
					alert(ret);
					obj.retGridPanelStore.reload();
				}
				else
				{
					ev.record.set('oproom','��');
					ev.record.set('opordno','δ��');
					ev.record.set('status','����');
					//obj.retGridPanelStore.reload();
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
				alert(ret);
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

						if(ret1!="") 
						{
						  alert(ret1);
                          ev.record.set('scrubnurse',ev.originalValue);
                        }						  
					}
					else 
					{
					 alert(ret);
               		 ev.record.set('scrubnurse',ev.originalValue);
                    }					 
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
					if(ret1!="") 
					{
					  alert(ret1) 
					  ev.record.set('scrubnurse',ev.originalValue);
					 }
					else
					{
						//alert("ϴ�ְ��ųɹ�")
					}
				}
				else 
				{
				  alert(ret)
				  ev.record.set('scrubnurse',ev.originalValue);
				}
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
						if(ret1!="") 
						{
							alert(ret1) ;
							ev.record.set('circulnurse',ev.originalValue);
						}
					}
					else 
					{	
					alert(ret);
					ev.record.set('circulnurse',ev.originalValue);
				    }
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
					if(ret1!="") 
					{
						alert(ret1);
						ev.record.set('circulnurse',ev.originalValue);
					}
					else 
					{
						//alert("Ѳ�ذ��ųɹ�");
					}
					
				}
				else 
					{
					alert(ret);
					ev.record.set('circulnurse',ev.originalValue);
				   }
			}
		}
	if(ev.field=='tNurseNote')
		{
		 note=ev.value;
		 if(note!="")
		 {
		 var ret=_DHCANOPArrange.UpdateOpNurseNote(opaId,note)
		 if(ret!='0')
		 alert(ret);
		 }
		 }
	}
	
function AppNewOper(appType,lnk,nwin)	//pat doctor new application
	{
		var opaId=""
		var EpisodeID=obj.EpisodeID.getValue();
		//lnk+="&opaId="+"&appType="+appType+"&EpisodeID="+EpisodeID;
		//window.open(lnk,'_blank',nwin)
		//var returnVal=window.showModalDialog(lnk,'_blank',nwin);
		//obj.btnSch_click();	
		lnk="dhcclinic.anop.app.csp?"
		lnk+="&opaId="+opaId+"&appType="+appType+"&EpisodeID="+EpisodeID+"&random="+Math.random();
                var nwin="dialogWidth:760px;dialogHeight:700px;status:no;menubar:no;"
		var returnVal=window.showModalDialog(lnk,'_blank',nwin)
                if(returnVal==1)
               {
		 obj.retGridPanelStore.reload()
               }
	}

function ManageOper(appType,lnk,nwin)  
	{
	    var count=obj.csm.getCount();
		if(count>1)
		{
			alert("ֻ��ѡ��һ������,������ѡ��");
			return;
		}
		var selectObj = obj.csm.getSelected(); //20130423
		if ((count==1)&&(selectObj)) 
		{
			var EpisodeID=selectObj.get('adm');
			var status=selectObj.get('status');
			if((appType=='ward')&&(status!='����')&&(status!=''))
			{
				alert("�ܲ���������״̬Ϊ: ���룬δ���")
				return;
			}      
			if((appType=='op')&&(status!='����')&&(status!='����'))
			{	     
				alert("�ܲ���������״̬Ϊ: ���룬����")
				return;
			}
			if((appType=='anaes')&&(status!='����')&&(status!='����'))
			{
				alert("�ܲ���������״̬Ϊ: ���룬����")
				return;
			}
			if((appType=='RegOp')&&(status!='����')&&(status!='����')&&(status!='���'))
			{
				alert("�ܲ���������״̬Ϊ: ���ţ����� �����")
				return;
			}
			var opaId=selectObj.get('opaId');
			//obj.opaId.setValue(opaId);
		}
		else 
		{
			alert("����ѡ��һ�У�");
			return;
		}
		if (opaId=="")
		{
			alert("����ѡ��һ�У�");
			return;
		}
		//lnk+="&opaId="+opaId+"&appType="+appType;
		//var returnVal=window.showModalDialog(lnk,'_blank',nwin);
		//obj.btnSch_click();
                lnk="dhcclinic.anop.app.csp?"
		lnk+="&opaId="+opaId+"&appType="+appType+"&EpisodeID="+EpisodeID+"&random="+Math.random();
                var nwin="dialogWidth:760px;dialogHeight:700px;status:no;menubar:no;"
		var returnVal=window.showModalDialog(lnk,'_blank',nwin)
                if(returnVal==1)
               {
		 obj.retGridPanelStore.reload()
               }
	}
	AnAtOperation=function(Type)
	{
		var count=obj.csm.getCount();
		if(count>1)
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
				alert("�ܲ���������״̬Ϊ:"+"����"+","+"����"+","+"����"+","+"���");
				return;
			}
			var str="";
			var opaId="";
			opaId=selectObj.get('opaId');
			var connectStr=_DHCClinicCom.GetConnectStr();
			var userCTLOCId=session['LOGON.CTLOCID'];
			//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANDisplay&icuaId="+opaId+"&connectStr="+connectStr+"&isSuperUser="+false+"&userCTLOCId="+userCTLOCId+"&documentType="+Type;
			//showModalDialog(lnk,"DHCAna","dialogWidth:1280px;dialogHeight:1024px;status:no;menubar:no;");
			//20150120
			var lnk="dhcanrecord.csp?opaId="+opaId;
			window.open(lnk,"DHC��������໤��Ϣϵͳ","height=900,width=1440,toolbar=no,menubar=no,resizable=yes");
		}
		else
		{
		  alert("��ѡ��һ��������¼");
		}
	}
	btnCancelOper_click=function()
	{
	  var idStr="";
	  var tmp=new Array();
	  var colNum=new Array();
	  var records=obj.csm.getSelections();
	  for(var i=0;i<records.length;i++)
	  {
	    var record=records[i];
        var rowIndex=obj.retGridPanelStore.indexOf(record)	
        var status=record.get('status');
		var opaId=record.get('opaId');	
        if(status!='����')
		{
		    obj.csm.deselectRow(rowIndex) //20130423
			continue;
		}	
        tmp[tmp.length]=rowIndex;
		colNum[colNum.length]=rowIndex+1;
		if(idStr=="") idStr=opaId;
		else idStr=idStr+"^"+opaId;		 
	  }
	  if(idStr=="")
	  {
		  alert("��ѡ��״̬Ϊ������ŵ�������");
		  return;
	  }
	else
	{
		var ifClear=confirm("�Ƿ�ȡ����"+colNum+"����¼������?")
		if(ifClear)
	    {
		  var ret=_DHCANOPArrange.ChangeAnopStat("C",idStr);
		  if(ret!=0)
		  {
			alert(ret);
		  }
		  else 
		  {
			for(var j=0;j<=tmp.length;j++)
			{
				var index=tmp[j];
				record=obj.retGridPanelStore.getAt(index);
                record.set("opStopStatus","I")
				obj.csm.deselectRow(index);//20130423
			}
		  }
		}
		else 
		{
		    for(var j=0;j<=tmp.length;j++)
			{
				var index=tmp[j];
				obj.csm.deselectRow(index);//20130423
			}
			return; 
		}  
	}		
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
				alert("�ܲ���������״̬Ϊ: ���ţ����У����ϣ��ָ��ң����")
			    return;
			}
			var opaId=selectObj.get('opaId');
		}
	  	if (opaId=="")
	  	{
	   		alert("��ѡ��һ��������¼");
	   		return;
	  	}
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPCount"
		var nwin="toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,height=700,width=960,top=0,left=0"
	   	lnk+="&opaId="+opaId+"&EpisodeID="+EpisodeID;
	   	window.open(lnk,'_blank',nwin);	
	}

	
	AnPdfDisplay=function()
	{
	 var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
		{
		    var status=selectObj.get('status');
			if ((status!='����')&&(status!='���')&&(status!='�ָ���'))
			{
				alert("�ܲ���������״̬Ϊ:"+"����"+","+"�ָ���"+","+"���");
				return;
			}
		    var str="";
			var opaId="";
			opaId=selectObj.get('opaId');
			var opStartDate=selectObj.get('opdatestr').split(" ")[0];
			var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANPdfDisplay&opaId="+opaId+"&opStartDate="+opStartDate;
			//var lnk= "../scripts/dhcclinic/an/showPDF.html"
			//showModalDialog(lnk,"DHCANPdfDisplay","dialogWidth:1280px;dialogHeight:1024px;status:yes;menubar:no;");
			window.open(lnk,"DHCANPdfDisplay","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=Yes,resizable=no,height=1024,width=1280,top=0,left=0");
			
		}
		else
		{
			alert("��ѡ��һ��������¼");
		}
	}

	function RefuseOper() {
		var idStr="";
		var tmp=new Array();
		var colNum=new Array();
	    var records=obj.csm.getSelections();
		for(var i=0;i<records.length;i++)
		{
		  var record=records[i];
		  var rowIndex=obj.retGridPanelStore.indexOf(record)
		  var status=record.get('status');
		  var opaId=record.get('opaId');
		  if((status!='����')&&(status!='����'))
		  {
		    obj.csm.deselectRow(rowIndex) //20130423
			  continue;
		  }
			tmp[tmp.length] = rowIndex;
			colNum[colNum.length] = rowIndex + 1;
			if (idStr == "") idStr = opaId;
			else idStr = idStr + "^" + opaId;
			}
		  if (idStr == "") {
			  alert("��ѡ��״̬Ϊ������ŵ�������");
		    return;
			}
		  else {
			var ifClear = confirm("�Ƿ�ܾ���" + colNum + "����¼������?")
				if (ifClear) {
					var ret = _DHCANOPArrange.ChangeAnopStat("D", idStr);
					if (ret != 0) {
						alert(ret);
					} else {
						 for (var j = 0; j <= tmp.length; j++) {
							var index = tmp[j];
							record = obj.retGridPanelStore.getAt(index);
							record.set('oproom', '��');
							record.set('opordno', 'δ��');
							record.set('status', '�ܾ�');
							obj.csm.deselectRow(index);
						}
					}
				} else {
					for (var j = 0; j <= tmp.length; j++) {
						var index = tmp[j];
						obj.csm.deselectRow(index);//20130423
					}
					return;
				}			
		}
	}


	
	
	
	function CancelRefusedOper() {			
		var idStr="";
		var tmp=new Array();
		var colNum=new Array();
	  var records=obj.csm.getSelections();
		for(var i=0;i<records.length;i++)
		{
		  var record=records[i];
		  var rowIndex=obj.retGridPanelStore.indexOf(record)
		  var status=record.get('status');
		  var opaId=record.get('opaId');
			if (status != '�ܾ�') {
					obj.csm.deselectRow(rowIndex) //20130423
					continue;
				}
				tmp[tmp.length]=rowIndex;
		    colNum[colNum.length]=rowIndex+1;
				if (idStr == "")
					idStr = opaId;
				else
					idStr = idStr + "^" + opaId;
			}
		if (idStr == "") {
			alert("��ѡ��״̬Ϊ�ܾ���������");
			return;
		} else {
			var ret = _DHCANOPArrange.ChangeAnopStat("A", idStr);
			if (ret != 0) {
			   alert(ret);
			} else {
			  alert("�ɹ�ȡ�������ܾ���");
				for (var j = 0; j <= tmp.length; j++) {
					var index = tmp[j];
					record = obj.retGridPanelStore.getAt(index);
					record.set('status', '����');
					obj.csm.deselectRow(index);
				}	

			}
		}
	}

	btnOpRoomLimit_click = function (btn) //�������������ƣ��й�ҽ���ã����ܲ�ͨ��
	{
		//var ret=_UDHCANOPArrange.UPDataOpDirAuditStatus('Y')
		//if (ret!=0) alert(ret);
		var ret = _DHCANOPArrange.UpDateOpDirAuditStatus()
			if ((ret == "N") || (ret == "")) {
				btn.setText("�����俪��");
			}
			if (ret == "Y") {
				btn.setText("����������");
			}
	}
	btnOpRoomOpen_click = function () //ȡ�����������ƣ��й�ҽ���ã����ܲ�ͨ��
	{
		var ret = _UDHCANOPArrange.UPDataOpDirAuditStatus('N')
			if (ret != 0)
				alert(ret);
	}

 function DHCCLMSAN()
	{
		var opaId="";
	    var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
	    var EpisodeID=obj.EpisodeID.getValue();
		var opaId=selectObj.get('opaId');
		var lnk= "dhcclinic.an.medicalSafety.csp?../scripts/dhcclinic/an/medicalSafety/gui.js"
		var nwin="toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,height=700,width=960,top=0,left=0"
	   	lnk+="&opaId="+opaId+"&EpisodeID="+EpisodeID;
	   	window.open(lnk,'_blank',nwin);	
	}	
	
	
	function PrintAnOpList(prnType, exportFlag) {
    if (prnType == "")
			return;
		var name,fileName,path,operStat,printTitle,operNum;
		var xlsExcel,xlsBook,xlsSheet;
		var row = 3;
		var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
		var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
		path = GetFilePath();
		printTitle = _UDHCANOPSET.GetPrintTitle(prnType);
		var printStr = printTitle.split("!");
		if (printTitle.length < 4)
			return;
		name = printStr[0];
		fileName = printStr[1];
		fileName = path + fileName;
		xlsExcel = new ActiveXObject("Excel.Application");
		xlsBook = xlsExcel.Workbooks.Add(fileName);
		xlsSheet = xlsBook.ActiveSheet;
		operStat = printStr[2];
		var strList = printStr[3].split("^")
		var printLen = strList.length;
		for (var i = 0; i < printLen; i++) {
			xlsSheet.cells(row, i + 1) = strList[i].split("|")[0];
		}
		var row = 3;
		operNum = 0;
		var preLoc = "";
		var preRoom = "",preSecLvEps="";
		var count = obj.retGridPanelStore.getCount(); //��������
		var selPrintTp = obj.chkSelPrint.getValue() ? 'S' : 'A';
		//�ܼ�
		var stDate= obj.dateFrm.getRawValue();
		var endDate = obj.dateTo.getRawValue();
		var stat=obj.comOperStat.getValue();
		var opRoom= obj.forComOpRoom.getValue();
		var apploc=obj.loc.getValue();
		var userLocId=obj.userLocId.getValue();
		var IsByAppDate=obj.chkIsAppT.getValue()?'1':'0';
		var MedCareNo=obj.txtMedCareNo.getValue();
		var patward=obj.PatWard.getValue();
		var logUserType;
		var chkIfAllLoc=obj.chkIfAllLoc.getValue()?'Y':'N';
		Condition="stDate:"+"'"+stDate+"'"+"endDate:"+"'"+endDate+"'"
		+"stat:"+"'"+stat+"'"+"opRoom:"+"'"+opRoom+"'"
		+"apploc:"+"'"+apploc+"'"+"userLocId:"+"'"+userLocId+"'"
		+"IsByAppDate:"+"'"+IsByAppDate+"'"+"MedCareNo:"+"'"+MedCareNo+"'"
		+"patward:"+"'"+patward+"'"+"logUserType:"+"'"+logUserType+"'"
		+"chkIfAllLoc:"+"'"+chkIfAllLoc+"prnType:"+"'"+"prnType"+"'"
		var retEpsStr="",retOpaStr="",ModelName="ANOPPrint"
		var userId=session['LOGON.USERID'];
		var locId=session['LOGON.CTLOCID'];
		var groupId=session['LOGON.GROUPID'];
		for (var i = 0; i < count; i++) 
		{
			var chk = ""
			var record = obj.retGridPanelStore.getAt(i);
			chk=obj.csm.isSelected(record)
			var stat = record.get('status');
			if (((selPrintTp == "A") && ((stat == operStat) || (operStat == ""))) || ((selPrintTp == "S") && (chk == true))) 
			{
				row = row + 1;
				operNum = operNum + 1;
				//Sort by loc, insert empty row between different loc
				var loc = record.get('loc');
				var locarr = loc.split("/");
				if (locarr.length > 1)loc = locarr[0];
				//-------�ܼ�
				var secLvEps = record.get('secId'); 
				if(secLvEps<preSecLvEps)
				{
					secLvEps=preSecLvEps
				}
				var EpsId = record.get('adm'); 
				if(retEpsStr!="") retEpsStr=retEpsStr+"^"+EpsId
				else retEpsStr=EpsId
				
				var secLvOpaId = record.get('opaId');
				if(retOpaStr!="") retOpaStr=retOpaStr+"^"+secLvOpaId
				else retOpaStr=secLvOpaId
				//-------
				var room = record.get('oproom'); 
				//�й�ҽ���ã���ͬ�������䣬����һ�����У���ͷ������
				if ((preRoom != "") && (preRoom != room)) 
				{
					row = row + 1;
					for (var n = 0; n < printLen; n++) 
					{
						xlsSheet.cells(row, n + 1) = strList[n].split("|")[0];
					}
					row = row + 1;
				}
				for (var j = 0; j < printLen; j++)
				 {
					var colName = strList[j].split("|")[1];
					var colVal = record.get(colName)
						if (colVal) 
						{
							if ((colName == "oproom") || (colName == "opordno")) 
							{
								if ((colVal == '��') || (colVal == 'δ��'))
									xlsSheet.cells(row, j + 1) = "";
								else
									xlsSheet.cells(row, j + 1) = colVal
							} 
							else if (colName == "opname") 
							{
								var opName = colVal.split(';');
								var colValLen = colVal.length;
								var firstOpNameLen = opName[0].length;
								xlsSheet.cells(row, j + 1).FormulaR1C1 = colVal;
								xlsSheet.cells(row, j + 1).Characters(1, firstOpNameLen).Font.Name = "����";
								xlsSheet.cells(row, j + 1).Characters(firstOpNameLen + 2, colValLen - firstOpNameLen).Font.Italic = true;
							} 
							else 
							{
								xlsSheet.cells(row, j + 1) = colVal;
							}
						} 
						else
							xlsSheet.cells(row, j + 1) = "";
				}
				preLoc = loc;
				preRoom = room;
				preSecLvEps=secLvEps;
				
			}
		}
		//ModelName, Condition, Content, SecretCode, Success, UserId, IP, Mac, CName, LocId, GroupId
		var secLvret=_DHCClinicCom.InsertLog(ModelName,Condition,retEpsStr+"/"+retOpaStr,preSecLvEps,"",userId,"", "", "",locId,groupId)
		
		PrintTitle(xlsSheet, prnType, printStr, operNum);
		titleRows = 3;
		titleCols = 1;
		LeftHeader = " ",
		CenterHeader = " ",
		RightHeader = " ";
		LeftFooter = "";
		CenterFooter = "";
		RightFooter = " &N - &P ";
		ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter);
		AddGrid(xlsSheet, 3, 0, row, printLen - 1, 3, 1);
		FrameGrid(xlsSheet, 3, 0, row, printLen - 1, 3, 1);
		if (exportFlag == "N") {
			//xlsExcel.Visible = true;
			//xlsSheet.PrintPreview;
			xlsSheet.PrintOut();
		} else {
			if (exportFlag == "Y") {
				var savefileName = "C:\\Documents and Settings\\";
				var savefileName = _UDHCANOPSET.GetExportParth()
					var d = new Date();
				savefileName += d.getYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate();
				savefileName += " " + d.getHours() + "," + d.getMinutes() + "," + d.getSeconds();
				savefileName += ".xls"
				xlsSheet.SaveAs(savefileName);
			}
		}
		xlsSheet = null;
		xlsBook.Close(savechanges = false)
		xlsBook = null;
		xlsExcel.Quit();
		xlsExcel = null;
	}

	function PrintTitle(objSheet,prnType,printStr,operNum)
	{
		var sheetName=printStr[0];	
		var setList=printStr[3].split("^")
		var colnum=setList.length;
		var hospitalDesc=_DHCClinicCom.GetHospital()
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
		var path=_UDHCANOPArrange.GetPath();
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

	//��������
	
	//��������
	function CancelOper()
	{	
		var idStr="";
		var tmp=new Array();
		var colNum=new Array();
		var records=obj.csm.getSelections();
		for(var i=0;i<records.length;i++)
		{
		  var record=records[i];
		  var rowIndex=obj.retGridPanelStore.indexOf(record)
		  var status=record.get('status');
		  var opaId=record.get('opaId');
			if (status != '����') {
					obj.csm.deselectRow(rowIndex) //20130423
					continue;
				}
				tmp[tmp.length]=rowIndex;
		    colNum[colNum.length]=rowIndex+1;
				if (idStr == "")
					idStr = opaId;
				else
					idStr = idStr + "^" + opaId;
			}

		if(idStr=="")
		{
			alert("��ѡ��״̬Ϊ�����������");
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
				if(status!='����')
				{
					alert("��Ȩ�޶Դ�״̬����������");
					return;
				}
			}
			var ifClear=confirm("�Ƿ�����"+colNum+"����¼������?")
			if(ifClear)
			{
	  			var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=CancelOper&opaId="+idStr;
	  			//window.showModalDialog(lnk,"CancelOper","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=200,width=700,top=100,left=300");
	  			window.open(lnk,"CancelOper","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=200,width=700,top=100,left=300");
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
	/*
	function CancelOper()
	{	
		var count=obj.csm.getCount();
		if(count>1)
		{
			alert("ֻ��ѡ��һ������,������ѡ��");
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
	  			//window.open(lnk,"CancelOper","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=200,width=700,top=100,left=300");
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
	}*/
}
