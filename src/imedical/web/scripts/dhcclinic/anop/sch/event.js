

function InitViewScreenEvent(obj)
{ 
	var _DHCANOPCom=ExtTool.StaticServerObject('web.DHCANOPCom');	
	var _UDHCANOPArrange=ExtTool.StaticServerObject('web.UDHCANOPArrange');
	var _UDHCANOPSET=ExtTool.StaticServerObject('web.UDHCANOPSET');
	var _DHCClinicCom=ExtTool.StaticServerObject('web.DHCClinicCom');
	var _DHCANOPArrange=ExtTool.StaticServerObject('web.DHCANOPArrange');
	var _DHCANOPArrangeClinics=ExtTool.StaticServerObject('web.DHCANOPArrangeClinics');
	var _DHCANArrange=ExtTool.StaticServerObject('web.DHCANArrange');
	var _DHCANAduitAccredit=ExtTool.StaticServerObject('web.DHCANAduitAccredit');
	var _DHCANOPCancelOper=ExtTool.StaticServerObject('web.DHCANOPCancelOper');
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
		//查询开始结束时间
		var ret=_DHCANOPCom.GetInitialDate(session['LOGON.USERID'],"",session['LOGON.CTLOCID']);
		obj.dateFrm.setValue(ret);
		//20161214+dyl
		var retto=_DHCANOPCom.GetInitialDateOld(session['LOGON.USERID'],"",session['LOGON.CTLOCID']);
		obj.dateTo.setValue(retto);
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
            obj.comAppLoc.setRawValue(loc[0]);	//20160908+dyl
			obj.loc.setValue(loc[1]);    

			if(loc[0].indexOf("门诊")>=0){  //add by lyn 20161024  标准库门诊手术设置
				obj.chkOutOP.setValue(true);
			} 			
	    }  
    //20170517+dyl+门诊默认勾上门诊手术室
    var ifOutSSS=_UDHCANOPArrange.GetIfOperLoc(session['LOGON.CTLOCID'])
	    if(ifOutSSS=="OUT")
	    {
		    obj.chkOutOP.setValue(true);
	    }
		var retw=_UDHCANOPArrange.GetNurWard(userId,session['LOGON.CTLOCID'])
		if (retw!=""){
			ward=retw.split("^");
			obj.comPatWard.setValue(ward[1]);
			obj.comPatWard.setRawValue(ward[0]);
		}
	    if(obj.comAppLoc.getRawValue()=="") obj.loc.setValue("");

	    var userType="";
	    userType=_DHCANOPCom.GetUserType(userId);
	    var logUserType=""; //lonon user type: ANDOCTOR,ANNURSE,OPNURSE
	    var sessLoc=session['LOGON.CTLOCID'];
	    obj.userLocId.setValue(sessLoc);
	    var ret=_UDHCANOPSET.ifloc(sessLoc);
	    if ((ret!=1)&&(ret!=2))   //手术室:ret=1,麻醉科:ret=2
	    {
			//alert(ret)
			//ward nurse:link location's operatoin apply
			//ward doctor: logon location's operatoin apply
			//alert(loc)
			//---暂时去掉测试
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
			width: 80
			});
		}
		if(logLocType=="AN")
		{  
			obj.tb.addItem({
			xtype: 'tbspacer', 
			width: 100
			});
		}
		if(logLocType=="App")
		{ 
			obj.tb.addItem({
			xtype: 'tbspacer', 
			width: 100
			});
		}

		var groupId=session['LOGON.GROUPID'];
		//
		var auditGroupId=_DHCANAduitAccredit.GetNewGroupIdbyAudit(sessLoc,userId,groupId)
		//
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
			param.Arg2 = auditGroupId;
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
					,iconCls:'icon-buttonshow'
					,style:'margin:0 1px;'
					,buttonAlign:'center'
					,handler:OnButtonClick
					});	
	                 if (records[i].data.name == "btnOpRoomLimit") {
						var opDirAuditStatus = _DHCANOPArrange.GetOpDirAuditStatus()
							if ((opDirAuditStatus == "N") || (opDirAuditStatus == "")) {
								btn.setText("手术间开放")
							}
							if (opDirAuditStatus == "Y") {
								btn.setText("手术间限制")
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
		if(session['LOGON.GROUPDESC'].indexOf("门诊")>=0){
			obj.chkOutOP.setValue(true);
		} 
		obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.UDHCANOPArrange';
			param.QueryName = 'GetAnOpList';
			param.Arg1 = obj.dateFrm.getRawValue();
			param.Arg2 = obj.dateTo.getRawValue();
			param.Arg3 = obj.comOperStat.getValue();
			if(obj.comOpRoom.getRawValue()=="")
			{
				obj.forComOpRoom.setValue("");
			}
			param.Arg4 = obj.forComOpRoom.getValue();
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
			if(obj.comPatWard.getRawValue()=="")
			{
				obj.comPatWard.setValue("");
			}
			param.Arg11 = obj.comPatWard.getValue();
			param.Arg12 = ""; //obj.chkUnPaidOp.getValue()?'Y':'N';
			param.Arg13 = logUserType;
			param.Arg14 = obj.chkIfAllLoc.getValue()?'Y':'N';
			param.Arg15 = obj.chkOutOP.getValue()?'O':'I'; //ADD BY LYN 标准库bug修正 20160927
			param.ArgCnt = 15;
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
			case 'btnOpRoomLimit': //中国医大用
				btnOpRoomLimit_click();
				break;
			case 'btnOpRoomOpen': //中国医大用
				btnOpRoomOpen_click();
				break;
			case 'btnDirAudit':
				btnDirAudit_click();
				break;
			case 'btnAnDocOrdered':
				btnAnDocOrdered_click();
			   break;
			case 'btnOPNurseOrdered':	//20161214+dyl
				btnOPNurseOrdered_click();
			   break;
		   case 'btnInRoom':
		    btnInRoom_click();
			break;
		   case 'btnLeave':
		    btnLeave_click();
			break;
		   case 'btnCancelOper': //撤销手术，不同于拒绝手术
		    	btnCancelOper_click();
	       break;
	       case 'CheckRiskAssessment': //手术风险评估：申请医生
		    	CheckRiskAssessment();
	       break;
	       case 'CheckSafetyInfo':	//手术安全核查：麻醉医生
				CheckSafetyInfo();
		   break;
		   case "OPControlledCost":		//可控成本
                OPControlledCost();
                break;
           case "ANEquip":	//麻醉设备管理
                ANEquip();
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
                AppNewOper('ward',lnk,nwin,"In");
                break;
            case "AppOperClinics":	 //门诊手术申请  add  by lyn  20160410
				AppNewOper('ward',lnk,nwin,"Out");
				break;
			case "AppIntervent":	 //介入手术申请  add  by lyn  20160410
				AppNewOper('ward',lnk,nwin,"Inter");
				break;
            case "AlterOper":
                ManageOper('ward',lnk,nwin,"In");
                break;
            case "UpdateOperClinics":  //门诊修改手术申请
				ManageOper('ward',lnk,nwin,"Out");
				break;
            case "ArrOper":				
                ManageOper('op',lnk,nwin,"In");
                break;  
            case "ArrOperClinics":  //门诊手术安排 add  by lyn  20160410
				ManageOper('op',lnk,nwin,"Out");  
				break;	
		    case "RefuseOper":
				RefuseOper();
				break;
		    case "CancelRef":
				CancelRefusedOper();
				break;
		    case "ArrAn":
				//ManageOper('anaes',lnk,nwin);	
				ManageOper('anaes',lnk,nwin,"In");   
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
				//ManageOper('RegOp',lnk,nwin);
				ManageOper('RegOp',lnk,nwin,"In");
				break;
			case "RegOperClinics": //门诊术后登记 add  by lyn  20160410
                ManageOper('RegOp',lnk,nwin,"Out");
                break;
            case "PrintMZSSYYD":
            	PrintMZSSYYD("MZSSYYD","N");
            	break;
            case "PrintSSYYDBNZ":  //add by lyn 20160410  白内障科室
				var closeWindow = confirm("是否导出？(取消将直接打印)");
				if(closeWindow) PrintAnOpList("SSYYDBNZ","Y");
                else PrintAnOpList("SSYYDBNZ","N");
                break;
            case "PrintSSYYDTY":  //add by lyn 20160517  眼科
				var closeWindow = confirm("是否导出？(取消将直接打印)");
				if(closeWindow) PrintAnOpList("SSYYDTY","Y");
                else PrintAnOpList("SSYYDTY","N");
                PrintAnOpList("SSYYDTY","N");
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
		    case "OperTransfer":     //病人转运申请 add by YuanLin 20170815
				OperTransfer();
				break;
			case "AduitAccredit":
				ManageAduitAccredit();
				break;
			    default:
			    break;
		}
	}
function ManageAduitAccredit()
{
		lnk = "dhcanaduitaccredit.csp?"
		window.open(lnk, "科主任授权", "height=600,width=1230,toolbar=no,menubar=no,resizable=no,scrollbars=yes");
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
		if(obj.comAppLoc.getRawValue()=="")
		{
			obj.comAppLoc.setValue("")
		}
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
	
/*	去除病案号自动填充的功能 modify by whl 20120514
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
			//20160918+dyl
			obj.txtPatname.setValue(selectObj.get('patname'));
			obj.txtPatSex.setValue(selectObj.get('sex'));
			obj.txtPatAge.setValue(selectObj.get('age'));
			obj.txtPatRegNo.setValue(selectObj.get('regno'));
			//
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
		else
		{
			obj.txtPatname.setValue('');
			obj.txtPatSex.setValue('');
			obj.txtPatAge.setValue('');
			obj.txtPatRegNo.setValue('');

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
			if ((status != '申请') && (status != '安排')) {
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
			alert("请勾选状态为申请或安排的手术! ");
			return;
			}
		 else {
			var ifClear = confirm("是否清空第" + colNum + "条记录的手术间")
				if (ifClear) {
					var ret = _DHCANOPArrange.ClearOpRoom(idStr);
					if (ret != '0') {
						alert(ret);
						obj.retGridPanelStore.reload();
					} else {
						for (var j = 0; j <= tmp.length; j++) {
							var index = tmp[j];
							record = obj.retGridPanelStore.getAt(index);
							record.set('oproom', '无');
							record.set('opordno', '未排');
							record.set('status', '申请');
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
		var count=obj.retGridPanel.getSelectionModel().getCount();
		if(count>1)
		{
			alert("只能选择一条手术,请重新选择！");
			return;
		}
		var opaId=selectObj.get('opaId');
		var status=selectObj.get('status');
		if((status=="申请")||(status=='拒绝'))
		{
			alert("不对此状态的手术操作!");
			return false;
		}
		ret=_UDHCANOPArrange.UpdateAnaDoctorOrdered(opaId,'Y');
		if (ret!=0) alert(ret);	
		else
		{
			alert("操作成功！");
			selectObj.set("anaDoctorOrd","Y")
			//obj.retGridPanelStore.reload();
		}
	}
	//20161214+dyl
	btnOPNurseOrdered_click = function()
	{
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		var count=obj.retGridPanel.getSelectionModel().getCount();
		if(count>1)
		{
			alert("只能选择一条手术,请重新选择！");
			return;
		}
		var opaId=selectObj.get('opaId');
		var status=selectObj.get('status');
		if((status=="申请")||(status=='拒绝'))
		{
			alert("不对此状态的手术操作!");
			return false;
		}
		ret=_UDHCANOPArrange.UpdateOPNurseOrdered(opaId,'Y');
		if ((ret!="Y")&&(ret!="N"))
		{
			alert(ret);	
			return;
		}
		else
		{
			alert("操作成功！");
			selectObj.set("opNurseOrd",ret)
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
			alert("请勾选状态为空的手术！");
			return;
		} else {
			var groupId = session['LOGON.GROUPID'];
			var ret = _DHCANOPArrange.SetAnOpDirAudit(idStr, groupId);
			if (ret != "0")
				alert(ret);
			else {
				alert("审核成功！");
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
			if ((status == '安排')&&(oprId!='')) {
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
		   alert("更新成功！")
		   for (var j = 0; j <= tmp.length; j++) {
			 var tmpIndex = tmp[j];
			 record = obj.retGridPanelStore.getAt(tmpIndex);
			 record.set('status', '术中');
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

		  if (status == '术中')
		  {
		   tmp[tmp.length] = rowIndex;
		   idStr = idStr + opaId + '^';
		  }
		  else
		  {
		   alert("请选择状态为术中的手术！")
		   //obj.csm.deselectRow(rowIndex);
		  }
		}
		if(idStr!="")
		{
		 var ret=_DHCANOPArrange.ChangeAnopStat("L",idStr)
		 if(ret!="0") alert(ret)
		 else 
		 {
		   alert("更新成功！")
		   for (var j = 0; j <= tmp.length; j++) {
		   var tmpIndex = tmp[j];
		   var record = obj.retGridPanelStore.getAt(tmpIndex);
		   record.set('status', '术毕');
		   obj.csm.deselectRow(tmpIndex);
					}
		  }
		}
		else obj.csm.clearSelections();
	}
	//判断是否可以编辑
	obj.retGridPanel_beforeedit = function (ev)
	{
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
		if ((status != '申请') && (status != '安排')&& (ev.field!='tPacuBed')) {
			alert("只能安排状态为安排的手术!");
			return false;
		}
		
		if ((ev.field=='tPacuBed')&& (status != '术毕')) {
			alert("只能安排术毕状态的病人!");
			return false;
		}
		
		if (ev.field == 'opordno') {
			var value = ev.record.data.oproom;
			if (value == '无') {
				alert("请首先安排手术间!");
				return false;
			}
		    if((obj.gdOpRoomStore.find('oprId',value)==-1)&&(obj.gdOpRoomStore.find('oprDesc',value)==-1))
		    {  
				alert(value+"不在本手术室，请重新安排手术间!");
				return false;
		    }
		}
		if(ev.field=='scrubnurse')   //lov
		{
			if(status!='安排') 
			{ 
				alert("请先安排手术!");
				return false;
			}
			//alert(logLocType+"/"+logLocType)
			//if((logLocType=="App")||(logLocType=="AN"))
			//{return false;}
		}
		if(ev.field=='circulnurse')   //lov
		{
			if(status!='安排') 
			{ 
				alert("请先安排手术!");
				return false;
			}
			//if((logLocType=="App")||(logLocType=="AN"))
			//{return false;}
		}
		//20170314+dyl+from yangqin
		if(ev.field=='anmethod')   //lov
		{
			if(status!='安排') 
			{ 
				alert("请先安排手术!");
				return false;
			}
			if(logLocType!="AN")
			{return false;}
		}
		if(ev.field=='andoc')   //lov
		{
			if(status!='安排') 
			{ 
				alert("请先安排手术!");
				return false;
			}
			if(logLocType!="AN")
			{return false;}
		}
	}

	obj.retGridPanel_validateedit=function(ev)
	{
	}
	obj.retGridPanel_afteredit=function(ev) //修改科室和台次
	{
		var maxNo=obj.maxOrdNo.getValue();  //最大台次和gui中ordNoStore中的n保持一致
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
				alert("无此手术间,请重新选择,否则该条手术安排无效!");
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
					ev.record.set('status','安排');
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
					ev.record.set('oproom','无');
					ev.record.set('opordno','未排');
					ev.record.set('status','申请');
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
				if(ret!='0') 
				{
					alert(ret);
					obj.retGridPanelStore.reload();
				}
				else
				{
					ev.record.set('status','安排');
				}
			}
			else
			{
				alert("台次不可为空,请选择台次")
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
                 //特别注意************添加巡回护士时，'D'换为'T'
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
						//alert("洗手安排成功")
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
				var ifEmpty=confirm("是否安排为空?")
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
                 //特别注意************添加巡回护士时，'D'换为'T'
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
						//alert("巡回安排成功");
					}
					
				}
				else 
					{
					alert(ret);
					ev.record.set('circulnurse',ev.originalValue);
				   }
			}
		}
		
					//恢复床位
		if(ev.field=='tPacuBed')
		{
			var PacuBed=ev.value;
			if(PacuBed==""){
				var ifEmpty=confirm("是否安排为空?")
				if(ifEmpty){
					var ret=_DHCANOPArrange.UpdatePacuBed(opaId,"")
					ev.record.set('tPacuBed',"");
					}
				}
				else
			    { 
		            var PacuBedId=_DHCANArrange.GetRoomIdByRoomDesc(PacuBed)     //湘雅医院床位ID与床号不匹配,如不需要可注释掉
				    var ret=_DHCANOPArrange.UpdatePacuBed(opaId,PacuBedId); 
				    ev.record.set('tPacuBed',PacuBed);
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
		 //20170314+dyl+from yangqin
		 if(ev.field=='andoc')
		{
			 var idStr=ev.value;
			 var ret=_DHCANOPArrange.UpdateAnArrDocAndMethod(opaId,idStr,"");
			 if(ret!=0)
			 {
				 alert(ret)
			 }
			 else
			 {
				 var index = obj.comAnaDocStore.find('ctcpId',idStr);
				if(index!=-1)
				{
					andoc=obj.comAnaDocStore.getAt(index).data.ctcpDesc;
					 ev.record.set('andoc',andoc);
				}
			 }
		}
		if(ev.field=='anmethod')
		{
			 var idStr=ev.value;
			 //alert(idStr)
			// return;
			 var ret=_DHCANOPArrange.UpdateAnArrDocAndMethod(opaId,"",idStr);
			 if(ret!=0)
			 {
				 alert(ret)
			 }
			 else
			 {
				 var index = obj.comAnaMethodStore.find('ID',idStr);
				if(index!=-1)
				{
					anmethod=obj.comAnaMethodStore.getAt(index).data.Des;
					 ev.record.set('anmethod',anmethod);
				}
			 }
		}

	}
	
	///update by lyn 手术申请
	///appCat:哪种申请类型;
	///		  Inter-内镜，介入科室手术申请; In-住院科室手术申请; Out门诊科室手术申请
	function AppNewOper(appType,lnk,nwin,appCat)   //pat doctor new application
    {
        var opaId=""
        var EpisodeID=obj.EpisodeID.getValue();  
        if(EpisodeID!="")
        {
	        //调整了diagwidth+20160930
			lnk="dhcclinic.anop.app.csp?"
			if(appCat=="Inter") lnk="dhcclinic.anop.appintervent.csp?"		//内镜手术申请
			if(appCat=="Out") lnk="dhcclinic.anop.appClinics.csp?"			//门诊手术申请
			lnk+="&opaId="+opaId+"&appType="+appType+"&EpisodeID="+EpisodeID+"&random="+Math.random();
			var nwin="dialogWidth:860px;dialogHeight:760px;status:no;menubar:no;"
			var returnVal=window.showModalDialog(lnk,'_blank',nwin)
			//window.open(lnk, "手术申请", "top=0,left=0,height=760,width=860,toolbar=no,menubar=no,resizable=no,scrollbars=yes");
			if(returnVal==1)
			{
				obj.retGridPanelStore.reload()
            }
        }
        else
        {
            alert("没有选中病人，无法申请手术")
        }
        
    }

	///update by lyn 20160410
	function ManageOper(appType,lnk,nwin,cat)  
	{
	    var count=obj.csm.getCount();
		if(count>1)
		{
			alert("只能选择一条手术,请重新选择！");
			return;
		}
		var selectObj = obj.csm.getSelected(); //20130423
		if ((count==1)&&(selectObj)) 
		{
			var EpisodeID=selectObj.get('adm');
			var status=selectObj.get('status');
			if((appType=='ward')&&(status!='申请')&&(status!=''))
			{
				alert("能操作的手术状态为: 申请，未审核")
				return;
			}      
			if((appType=='op')&&(status!='申请')&&(status!='安排'))
			{	     
				alert("能操作的手术状态为: 申请，安排")
				return;
			}
			if((appType=='anaes')&&(status!='安排'))
			{
				alert("能操作的手术状态为: 安排")
				return;
			}
			if((appType=='RegOp')&&(status!='安排')&&(status!='术毕')&&(status!='恢复室')&&(status!='完成'))
			{
				alert("能操作的手术状态为: 安排，术毕 ，恢复室，完成")
				return;
			}
			var opaId=selectObj.get('opaId');
			//obj.opaId.setValue(opaId);
		}
		else 
		{
			alert("请先选中一行！");
			return;
		}
		if (opaId=="")
		{
			alert("请先选中一行！");
			return;
		}
		//lnk+="&opaId="+opaId+"&appType="+appType;
		//var returnVal=window.showModalDialog(lnk,'_blank',nwin);
		//obj.btnSch_click();
        lnk="dhcclinic.anop.app.csp?"
        if(cat=="Out") lnk="dhcclinic.anop.appClinics.csp?"
		lnk+="&opaId="+opaId+"&appType="+appType+"&EpisodeID="+EpisodeID+"&random="+Math.random();
        var nwin="dialogWidth:860px;dialogHeight:760px;status:no;menubar:no;"
		var returnVal=window.showModalDialog(lnk,'_blank',nwin)
        if(returnVal==1)
        {
			obj.retGridPanelStore.reload()
        }
	}
	//cdx 151023  可控成本管理
	OPControlledCost = function () 
	{
		var count = obj.csm.getCount();
		if (count > 1) {
			alert("只能选择一条手术,请重新选择！");
			return;
		}
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj) {
			var status = selectObj.get('status'),
					opaId = selectObj.get('opaId'),
					userId = session["LOGON.USERID"],
					lnk = "dhcclinic.anop.controlledcost.csp?opaId=" + opaId + "&userId=" + userId;
			var nwin="dialogWidth:1160px;dialogHeight:590px;status:no;menubar:no;"
			//var returnVal=window.showModalDialog(lnk,'_blank',nwin)
			window.open(lnk, "可控成本管理", "top=0,left=0,height=580,width=1160,toolbar=no,menubar=no,resizable=no,scrollbars=yes");
		}
		else {
			alert("请选择一条手术记录");
    }
}
	//cdx 151116 麻醉设备管理
	ANEquip = function () {
		var count = obj.csm.getCount();
		if (count > 1) {
			alert("只能选择一条手术，请重新选择！");
			return;
		}
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj) {
			var status = selectObj.get('status'),
			opaId = selectObj.get('opaId'),
			userId = session["LOGON.USERID"],
			lnk = "dhcclinic.anop.anequip.csp?opaId=" + opaId + "&userId=" + userId;
			window.open(lnk, "麻醉设备管理", "height=600,width=1230,toolbar=no,menubar=no,resizable=no,scrollbars=yes");
		}
		else {
			alert("请选择一条手术记录");
		}
	}
	AnAtOperation=function(Type)
	{
		var count=obj.csm.getCount();
		if(count>1)
		{
			alert("只能选择一条手术,请重新选择！");
			return;
		}
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
		{
			var status=selectObj.get('status');
			if ((status!='安排')&&(status!='术毕')&&(status!='术中')&&(status!='恢复室')&&(status!='完成'))
			{
				alert("能操作的手术状态为:"+"安排"+","+"术中"+","+"术毕"+","+"恢复室"+","+"完成");
				return;
			}
			var str="";
			var opaId="";
			opaId=selectObj.get('opaId');
			var connectStr=_DHCClinicCom.GetConnectStr();
			var userCTLOCId=session['LOGON.CTLOCID'];
			//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANDisplay&icuaId="+opaId+"&connectStr="+connectStr+"&isSuperUser="+false+"&userCTLOCId="+userCTLOCId+"&documentType="+Type;
			//var lnk= "dhcanrecord.csp?opaId="+opaId+"&EpisodeID="+EpisodeID+"&isSuperUser="+false+"&userCTLOCId="+userCTLOCId+"&documentType="+Type;  //"AN";
			//alert(lnk);
			//showModalDialog(lnk,"DHCAna","dialogWidth:1280px;dialogHeight:1024px;status:no;menubar:no;");
		    var lnk="../service/dhcclinic/app/an/anmain.application?opaId="+opaId+"&userId="+session["LOGON.USERID"]+"&groupId="+session["LOGON.GROUPID"]+"&locId="+userCTLOCId+"&connString="+connectStr+"&documentType="+Type;
		    window.open(lnk);
		}
		else
		{
		  alert("请选择一条手术记录");
		}
	}
	//20161214+dyl
	btnCancelOper_click=function()
	{
	 	var count=obj.csm.getCount();
		if(count>1)
		{
			alert("只能选择一条手术,请重新选择！");
			return;
		}
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		var opaId=selectObj.get('opaId');
		var status=selectObj.get('status');

		if((status!='申请')&&(status!=''))
		{
			alert("能操作的手术状态为:"+"申请");
			return;
		}
	  	if(opaId=="")
	  	{
		  alert("请选择状态为申请的手术！");
		  return;
	  	}
		else
		{
			var ifClear=confirm("是否取消此条记录的手术?")
			if(ifClear)
		    {
			   //这块准备加弹出窗口
			  // var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=CancelOper&opaId="+opaId;
			   //window.open(lnk, "撤销手术", "top=0,left=0,height=240,width=420,toolbar=no,menubar=no,resizable=no,scrollbars=yes");
			     //20170831+dyl
			     var lnk = "CancelOperExt.csp?opaId=" + opaId ;
					var nwin="dialogWidth:260px;dialogHeight:160px;status:no;menubar:no;"
					var returnVal=window.showModalDialog(lnk,'_blank',nwin);
			   if(returnVal==1)
			{
				obj.retGridPanelStore.reload()
            			}
		    }
		    else 
			{
			    for(var j=0;j<=tmp.length;j++)
				{
					var index=tmp[j];
					obj.csm.deselectRow(index);//20130423
				}
			}		
		}
	}
	//手术转运单
	function OperTransfer()
	{
		var opaId="";
		var EpisodeID=obj.EpisodeID.getValue(); 
		var count=obj.csm.getCount();
		if(count>1)
		{
			alert("只能选择一条手术,请重新选择！");
			return;
		}
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
		{ 
			opaId=selectObj.get("opaId");
		        status=selectObj.get('status');
		}
		if(opaId=="")
		{
			alert("请选择一条手术！");
			return; 
		}
		if((status=='拒绝')||(status=='撤销'))
		{
			alert("拒绝或撤销状态的手术不可进行病人转运申请！");
			return;
		}
		var lnk="dhcclinic.transfer.app.csp?opaId="+opaId+"&EpisodeID="+EpisodeID;
		var nwin="dialogWidth:1150px;dialogHeight:760px;status:no;menubar:no;"
		window.open(lnk,'_blank',nwin)
	}
	//手术风险评估
	function CheckRiskAssessment(lnk,nwin)	                       //手术安全核查
	{   
		var count=obj.csm.getCount();
	    if(count>1)
		{
			alert("只能选择一条手术,请重新选择！");
			return;
		}
		var selectObj = obj.csm.getSelected();
		
		if ((count==1)&&(selectObj)) 
		{
				var EpisodeID=selectObj.get('adm');
			var status=selectObj.get('status');
			var opaId=selectObj.get('opaId');
		}
		else 
		{
			alert("请先选中一行！");
			return;
		}
		if (opaId=="")
		{
			alert("请先选中一行！");
			return;
		}
		   lnk="dhcanopriskassessment.csp?"
		   lnk+="&opaId="+opaId;
		  var nwin="dialogWidth:1210px;dialogHeight:600px;status:no;menubar:no;"
		   var returnVal=window.showModalDialog(lnk,'_blank',nwin) 
		  //window.open(lnk,"手术风险评估","top=0,left=0,height=590,width=1210,scrollbars=yes,toolbar=no,menubar=no,resizable=no");
	}		
	//手术安全核查
	CheckSafetyInfo=function()
	{
		var count=obj.csm.getCount();
		if(count>1)
		{
			alert("只能选择一条手术,请重新选择！");
			return;
		}
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
		{
			var status=selectObj.get('status'),
			opaId=selectObj.get('opaId'),
			userId=session["LOGON.USERID"],
			lnk="DHCANSafetyChecking.csp?opaId="+opaId+"&userId="+userId;
			//var iLeft = (window.screen.availWidth-108-1150) //获得窗口的水平位置;
			//window.open(lnk,"手术安全核查","top="+0+", left="+iLeft+",height="+720+",width="+1150+",scrollbars=yes,toolbar=no,menubar=no,resizable=no");
		    var nwin="dialogWidth:1150px;dialogHeight:720px;status:no;menubar:no;"
			var returnVal=window.showModalDialog(lnk,"手术安全核查",nwin);
			if(returnVal==1)
			{
				obj.retGridPanelStore.reload()
            }
		}
		else
		{
		  alert("请选择一条手术记录");
		}
	}
	//2016-08-04
	function ANOPCount(lnk,nwin)
	{
		var opaId="";
	    var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
	    if (selectObj)
		{
		    var status=selectObj.get('status');
			if((status!='安排')&&(status!='术中')&&(status!='术毕')&&(status!='恢复室')&&(status!='完成'))
			{
				alert("能操作的手术状态为: 安排，术中，术毕，恢复室，完成")
			    return;
			}
			var opaId=selectObj.get('opaId');
		}
	  	if (opaId=="")
	  	{
	   		alert("请选择一条手术记录");
	   		return;
	  	}
		
		var lnk="dhcanopcountrecord.csp?opaId="+opaId+"&userId="+session["LOGON.USERID"];
		var nwin="dialogWidth:1150px;dialogHeight:760px;status:no;menubar:no;"
		//var returnVal=window.showModalDialog(lnk,'_blank',nwin)
		//window.open(lnk,"手术清点","top=0,left=0,height="+(window.screen.availHeight-40)+",width="+(window.screen.availWidth-100)+",toolbar=no,menubar=no,resizable=yes,scrollbars=yes");
		window.open(lnk,"手术清点","top=0,left=0,height=760,width=1150,toolbar=no,menubar=no,resizable=no,scrollbars=yes");
		
	}
	function ANOPCountOld(lnk,nwin)
	{
		var opaId="";
	    var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
	    if (selectObj)
		{
		    var status=selectObj.get('status');
			if((status!='安排')&&(status!='术中')&&(status!='术毕')&&(status!='恢复室')&&(status!='完成'))
			{
				alert("能操作的手术状态为: 安排，术中，术毕，恢复室，完成")
			    return;
			}
			var opaId=selectObj.get('opaId');
		}
	  	if (opaId=="")
	  	{
	   		alert("请选择一条手术记录");
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
			if ((status!='术毕')&&(status!='完成')&&(status!='恢复室'))
			{
				alert("能操作的手术状态为:"+"术毕"+","+"恢复室"+","+"完成");
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
			alert("请选择一条手术记录");
		}
	}

	function RefuseOper() 
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
		  if((status!='申请')&&(status!='安排'))
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
			  alert("请选择状态为申请或安排的手术！");
		    return;
			}
		  else {
			var ifClear = confirm("是否停止第" + colNum + "条记录的手术?")
				if (ifClear) {
					var ifInsertLog=""	//插入日志
					 ifInsertLog=_DHCANOPCancelOper.IfInsertLog()
					 if(ifInsertLog=="Y")
						{
							var clclogId="",logRecordId="",preValue="",preAddNote="",postValue="",postAddNote=""
							clclogId="RefuseOper";
							preAddNote="Pre手术状态";
							userId=session['LOGON.USERID'];
							logRecordId=opaId;
							postValue="D";
							postAddNote="拒绝成功";
							var wshNetwork = new ActiveXObject("WScript.Network");  
					 		var userd=wshNetwork.UserDomain;  
					 		var userc=wshNetwork.ComputerName;  
					 		var useru=wshNetwork.UserName;  
							var ipconfig=userd+":"+userc+":"+useru;
							var retCllog=_DHCANOPCancelOper.InsertCLLog(clclogId,logRecordId,preValue,preAddNote,postValue,postAddNote,userId,ipconfig)
							 } 
					//插入日志
					var ret = _DHCANOPArrange.ChangeAnopStat("D", idStr);
					if (ret != 0) {
						alert(ret);
					} else {
						 for (var j = 0; j <= tmp.length; j++) {
							var index = tmp[j];
							record = obj.retGridPanelStore.getAt(index);
							record.set('oproom', '无');
							record.set('opordno', '未排');
							record.set('status', '拒绝');
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
			if (status != '拒绝') {
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
			alert("请选择状态为拒绝的手术！");
			return;
		} else {
			var ret = _DHCANOPArrange.ChangeAnopStat("A", idStr);
			if (ret != 0) {
			   alert(ret);
			} else {
			  alert("成功取消手术停止！");
				for (var j = 0; j <= tmp.length; j++) {
					var index = tmp[j];
					record = obj.retGridPanelStore.getAt(index);
					record.set('status', '申请');
					obj.csm.deselectRow(index);
				}	

			}
		}
	}

	btnOpRoomLimit_click = function (btn) //激活手术间限制，中国医大用，可能不通用
	{
		//var ret=_UDHCANOPArrange.UPDataOpDirAuditStatus('Y')
		//if (ret!=0) alert(ret);
		var ret = _DHCANOPArrange.UpDateOpDirAuditStatus()
			if ((ret == "N") || (ret == "")) {
				btn.setText("手术间开放");
			}
			if (ret == "Y") {
				btn.setText("手术间限制");
			}
	}
	btnOpRoomOpen_click = function () //取消手术间限制，中国医大用，可能不通用
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
	
	function PrintAnOpList(prnType, exportFlag) 
	{
    	if (prnType == "")return;
		var name,fileName,path,operStat,printTitle,operNum;
		var xlsExcel,xlsBook,xlsSheet;
		var row = 3;
		var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
		var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
		path = GetFilePath();
		//本地测试
		//path="D:\\DtHealth\\app\\dthis\\med\\Results\\Template\\"
		printTitle = _UDHCANOPSET.GetPrintTitle(prnType);
		var printStr = printTitle.split("!");
		if (printTitle.length < 4)return;
		name = printStr[0];
		fileName = printStr[1];
		fileName = path + fileName;
		//alert(fileName)
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
		var preRoom = "";
		var count = obj.retGridPanelStore.getCount(); //数据行数
		var selPrintTp = obj.chkSelPrint.getValue() ? 'S' : 'A';
		for (var i = 0; i < count; i++) {
			var chk = ""
			var record = obj.retGridPanelStore.getAt(i);
			chk=obj.csm.isSelected(record)
			var stat = record.get('status');
			if (((selPrintTp == "A") && ((stat == operStat) || (operStat == ""))) || ((selPrintTp == "S") && (chk == true))) {
			row = row + 1;
				operNum = operNum + 1;
				//Sort by loc, insert empty row between different loc
				var loc = record.get('loc');
				var locarr = loc.split("/");
				if (locarr.length > 1)
					loc = locarr[0];
				var room = record.get('oproom'); //中国医大用，不同的手术间，插入一条空行，表头重新起。
				/*if ((preRoom != "") && (preRoom != room)) {
					row = row + 1;
					for (var n = 0; n < printLen; n++) {
						xlsSheet.cells(row, n + 1) = strList[n].split("|")[0];
					}
					row = row + 1;
				}*/
				for (var j = 0; j < printLen; j++) {
					var colName = strList[j].split("|")[1];
					var colVal = record.get(colName)
						if (colVal) {
							if ((colName == "oproom") || (colName == "opordno")) {
							if ((colVal == '无') || (colVal == '未排'))
									xlsSheet.cells(row, j + 1) = "";
								else
									xlsSheet.cells(row, j + 1) = colVal
							} else if (colName == "opname") {
								var opName = colVal.split(';');
								var colValLen = colVal.length;
								var firstOpNameLen = opName[0].length;
								xlsSheet.cells(row, j + 1).FormulaR1C1 = colVal;
								xlsSheet.cells(row, j + 1).Characters(1, firstOpNameLen).Font.Name = "宋体";
								xlsSheet.cells(row, j + 1).Characters(firstOpNameLen + 2, colValLen - firstOpNameLen).Font.Italic = true;
							} else {
								xlsSheet.cells(row, j + 1) = colVal;
							}
						} else
							xlsSheet.cells(row, j + 1) = "";
				}
				preLoc = loc;
				preRoom = room;
			}
		}
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
		if (tmpOperStartDate.length>2) operStartDate=tmpOperStartDate[2]+" 年 "+tmpOperStartDate[1]+" 月 "+tmpOperStartDate[0]+" 日";
		mergcell(objSheet,2,1,colnum);
		fontcell(objSheet,2,1,colnum,10);
		objSheet.cells(2,1)=operStartDate;
		var operEndDate=obj.dateTo.getRawValue();
		var tmpOperEndDate=operEndDate.split("/");
		if (tmpOperEndDate.length>2) operEndDate=tmpOperEndDate[2]+" 年 "+tmpOperEndDate[1]+" 月 "+tmpOperEndDate[0]+" 日";
		
		if (prnType=="SSD") 
		{
			if(operEndDate!=operStartDate)
			{
				objSheet.cells(2,1)=operStartDate+"  至  "+operEndDate+"             "+'手术台数:'+" "+operNum;
			}
			else
			{
				objSheet.cells(2,1)=operStartDate+"                "+'手术台数:'+" "+operNum;
			}
		}
		if (prnType=="MZD") objSheet.cells(2,1)=operStartDate;
        var apploc=obj.comAppLoc.getRawValue();
        var applen=apploc.split("-");
        var applocDesc=""
        if(applen.length>1) 
        {
	        applocDesc=applen[1];
        }
        else
        {
	        applocDesc=applen;
        }
        if (prnType=="SQD") objSheet.cells(2,1)=operStartDate+"    "+'申请科室:'+" "+applocDesc;
		if (prnType=="SSYYDBNZ"||prnType=="SSYYDTY") objSheet.cells(2,1)=operStartDate+"             "+operNum+" 例     "+session['LOGON.USERNAME'];
	}
	function GetFilePath()
	{
		var path=_DHCClinicCom.GetPath();
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

	//撤销手术
	
	//撤销手术
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
			if (status != '申请') {
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
			alert("请选择状态为申请的手术！");
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
				if(status!='申请')
				{
					alert("无权限对此状态的手术操作");
					return;
				}
			}
			var ifClear=confirm("是否撤销第"+colNum+"条记录的手术?")
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
	
	///门诊手术预约单打印
	///LYN ADD 20160414
	function PrintMZSSYYD(prnType,exportFlag)
	{
		if (prnType=="") return;
		var records=obj.csm.getSelections();
		if(records.length!=1) {alert("请勾选一条打印的记录");return;}
		
		var printInfo=_DHCANOPArrangeClinics.GetMZSSMZYYD(records[0].get("opaId")); //获取打印信息
		if(printInfo=="") return ;
		var name,fileName,path,operStat,printTitle,operNum;
		var xlsExcel,xlsBook,xlsSheet;
		var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
		var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
		path=GetFilePath();
		
		fileName=path+prnType+".xls";
		try{
		xlsExcel = new ActiveXObject("Excel.Application");
		xlsBook = xlsExcel.Workbooks.Open(fileName);
		}
		catch(e){
			alert(e.name+"^"+e.message+"^"+e.description+"^"+e.number)
			}
		xlsSheet = xlsBook.ActiveSheet;
		
		
		//var loc=window.status.split(':')[3].split(' ')[1];
		//alert(loc)
		//var hospital=window.status.split(':')[3].split(' ')[2]
		//var hospitalDesc="首都医科大学附属"+hospital;
		///***************打印表头**************
		var hospital=_DHCClinicCom.GetHospital();
		xlsSheet.cells(1,1)=hospital;
			var position=""
		position=printInfo.split('^')[14];
		//alert(position)
		xlsSheet.cells(1,8)=position;	//手术部位
		var appointnum=""	//预约号
		appointnum=printInfo.split('^')[19]+"";
		xlsSheet.cells(2,8)=appointnum;	
		var appdept=""	//预约科室
		appdept=printInfo.split('^')[13];
		xlsSheet.cells(2,1)="    "+appdept+"手术预约单";
		var patname=""	//患者姓名
		patname=printInfo.split('^')[0];
		xlsSheet.cells(3,2)=patname; 
		var patgender=""	//性别
		patgender=printInfo.split('^')[1];
		xlsSheet.cells(3,4)=patgender;	
		//DZY^女^25岁^^370***********641X^
		//13649500432^^^^^
		//头部血管治疗性超声^^医生01^手术室^内分泌门诊^
		//左前胸^27/09/2017^27/09/2017 09:00^27/09/2017 ^测试模板hkdhfkhfkdhfiehie^
		//^kkdkfdsfkd
		var patage=""	//年龄
		patage=printInfo.split('^')[2];
		xlsSheet.cells(3,6)=patage;	
		var patmed=""  //病案号
		patmed=printInfo.split('^')[3];
		xlsSheet.cells(3,8)=patmed;	
		var patidnum=""	//身份证号
		patidnum=printInfo.split('^')[4];
		xlsSheet.cells(4,2)=patidnum;
		var patworkplace=""	//工作单位
		patworkplace=printInfo.split('^')[6];
		xlsSheet.cells(4,5)=patworkplace;
		var patphone=""		//电话
		patphone=printInfo.split('^')[5];		
		xlsSheet.cells(5,2)="'"+patphone; 
		var pataddress=""
		pataddress=printInfo.split('^')[7];
		xlsSheet.cells(5,5)=pataddress; //家庭住址
		var patmedinfo=""
		patmedinfo=printInfo.split('^')[20];
		xlsSheet.cells(6,2)=patmedinfo;	//病历摘要
		var patdiag=""
		patdiag=printInfo.split('^')[8];	//诊断
		xlsSheet.cells(7,2)=patdiag;
		var opname="" //手术名称
		opname=printInfo.split('^')[9];
		xlsSheet.cells(8,2)=opname;
		var opsurgeon=""
		opsurgeon=printInfo.split('^')[10];
		xlsSheet.cells(9,2)=opsurgeon; //手术医生
			 
		var oploc=""	//手术科室
		oploc=printInfo.split('^')[12];
		xlsSheet.cells(9,4)=oploc;
		var appointtime="" //预约日期
		appointtime=printInfo.split('^')[16];
		xlsSheet.cells(9,7)=appointtime;
		var appdoc=""	//申请医生
		appdoc=printInfo.split('^')[11]
		xlsSheet.cells(10,2)=appdoc;	
		var apploc=""	//申请科室
		apploc=printInfo.split('^')[13];
		xlsSheet.cells(10,4)=apploc;
		var apptime=""	//申请时间
		apptime=printInfo.split('^')[15];
		xlsSheet.cells(10,7)=apptime;
		
		var patnotice=""	//病人须知
		patnotice=printInfo.split('^')[18];
		xlsSheet.cells(12,1)=patnotice;
		var cometime=""	//来院时间
		cometime=printInfo.split('^')[17];
		xlsSheet.cells(12,7)=cometime;
		
		
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
		xlsSheet.PrintOut();
		xlsSheet = null;
		xlsBook.Close(savechanges=false)
		xlsBook = null;
		xlsExcel.Quit();
		xlsExcel = null;
		
	}
    
		
	///导出数据
	obj.exportExcel_click=function ()
	{
		var operNum;
		var xlsExcel,xlsBook,xlsSheet;
		var row=1;
		xlsExcel = new ActiveXObject("Excel.Application");
		xlsBook = xlsExcel.Workbooks.Add();
		xlsSheet = xlsBook.ActiveSheet;
		var count=obj.retGridPanelStore.totalLength; //数据总数
		var columnModel=obj.retGridPanel.getColumnModel();		//alert("columnModel:"+columnModel)
		var cols=columnModel.getColumnCount();//显示列数
		var colNum=0,colCount=0
		for(var j=1;j<cols;j++)
		{
			var colName=columnModel.getDataIndex(j);
			if(colName=="") continue;
			var colVal=columnModel.getColumnHeader(j);
			colNum=colNum+1;
			colCount=colCount+1;
			if(colVal)
			{
				xlsSheet.cells(row,colNum)=colVal;
			}
			else xlsSheet.cells(row,colNum)="";
		}
		xlsSheet.Range(xlsSheet.Cells(1, 1), xlsSheet.Cells(1,colCount)).Font.Size = 14;
		//xlsSheet.Range(xlsSheet.Cells(1, 1), xlsSheet.Cells(1,colCount)).Font.Bold = true;
		row=row+1;
		for (var i=0;i<count;i++)
		{
			colNum=0;
			var record = obj.retGridPanelStore.getAt(i);
			for(var j=1;j<cols;j++)
			{
				var colName=columnModel.getDataIndex(j);
				if(colName=="") continue;
				var colVal = record.get(colName)
				colNum=colNum+1
				if(colVal)
				{
					xlsSheet.cells(row,colNum)=colVal;
				}
				else xlsSheet.cells(row,colNum)="";
			}
			row=row+1;
		}
		xlsSheet.Range(xlsSheet.Cells(1,1), xlsSheet.Cells(row-1,colCount)).Borders.Weight = 2;
		xlsSheet.Range(xlsSheet.Cells(1,1), xlsSheet.Cells(row-1,colCount)).Borders.LineStyle = 1;
		xlsExcel.Visible = true;
	}
	/*
	function CancelOper()
	{	
		var count=obj.csm.getCount();
		if(count>1)
		{
			alert("只能选择一条手术,请重新选择！");
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
