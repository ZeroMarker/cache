var objScreen = new Object();
function InitFrontPage(){
    var obj = objScreen;
	
	var IsSuperPower = 0;
	if (tDHCWMRMenuOper){				//update by niepeng 20150130 编目权限控制
		for (var code in tDHCWMRMenuOper) {
			if ((code != 'Super')&&(code != 'Browse')&&(code != 'Catalog')) continue;
			if (code == 'Super'){		//超级编目权限
				var hasPower = tDHCWMRMenuOper[code];
				if(hasPower == 0) continue;
				IsSuperPower = 1;
			}
			if (code == 'Browse'){	//浏览编目权限
				var hasPower = tDHCWMRMenuOper[code];
				if(hasPower == 0) continue;
				IsSuperPower = 2;
			}
			if (code == 'Catalog'){		//普通编目权限
				var hasPower = tDHCWMRMenuOper[code];
				if(hasPower == 0) continue;
				IsSuperPower = 3;
			}
		}
	}

	obj.FrontPage = new Object();
	obj.FrontPage.LogonLocID  = LogonLocID;   //登录科室
	obj.FrontPage.LogonHospID = LogonHospID;  //登录科室对应医院（CT_Hospital）
	obj.FrontPage.SubmitPower = IsSuperPower; //超级修改权限（允许修改别人提交的内容）
	obj.FrontPage.SSHospCode  = SSHospCode;   //登录科室对应医院代码（DHCWMR.SS.Hospital）
	obj.FrontPage.FrontPageID = FrontPageID;
	obj.FrontPage.VolumeID    = VolumeID;
	obj.FrontPage.FPType      = FPType;
	obj.FrontPage.IsFinish    = IsFinish;
	obj.FrontPage.MrTypeID    = MrTypeID;
	obj.FrontPage.WFItemID    = WFItemID;
	obj.FrontPage.FPItemID    = FPItemID;
	obj.FrontPage.VolPaadm    = VolPaadm;
	obj.FrontPage.AdmitDate   = AdmitDate;
	obj.FrontPage.DischDate   = DischDate;
	obj.FrontPage.PatientID   = PatientID;
	
	InitFrontPageEvent(obj);  //加载事务处理
	//InitFPPatInfo(obj);       //加载病人基本信息
	InitFPDiagnos(obj);       //加载诊断信息
	InitFPOperation(obj);     //加载手术信息
	//InitFPExtraItem(obj);     //加载其他信息
	InitFPMainInfo(obj);
	//InitFPSubInfo(obj);
	InitPatCost(obj);			//加载费用信息
	
	var htmlMainPanel = ''
		+ '<div> <table><td><tr>' // add by cpj 2017-12-19 若用 position:absolute; 还必须定义左边距和右边距 ;ie9上下跳动
		+ '<table align="center" border=0 cellpadding=0 cellspacing=0 style="border:1px solid #84C1FF;border-collapse:collapse;width:1200px;">'  
		
		+ '		<tr><td width="100%"><div style="width=100%;text-align:center;padding:10px;">'
		+ '		<span style="font-size:28px;"><b>病案编目首页</b></span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;">'
		+ '			<div style="width=100%;">'
		+ '				<span style="font-size:16px;"><b>病人基本信息</b></span>'
		+ '     	</div>'
		+ '		</td></tr>'
		+ '		<tr><td width="100%"><div id="divMainIfno-FP" style="width=100%;"></div></td></tr>'
		
		+ '		<tr><td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;">'
		+ '			<div style="width=100%;">'
		+ '				<span style="font-size:16px;"><b>诊断信息</b></span>&nbsp;&nbsp;&nbsp;&nbsp;'
		+ '     		<span onclick="objScreen.DivExpand(\'divDiagnos-DS\');" style="font-size:12px;color=red;">显示首页诊断</span>'
		+ '			</div>'
		+ '		</td></tr>'
		+ '		<tr><td width="100%"><div id="divDiagnos-DS" style="width=100%;display:none;"></div></td></tr>'
		+ '		<tr><td width="100%"><div id="divDiagnos-FP" style="width=100%;"></div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '         <table><tr style="height:30px;">'
		+ '		         	<td align="center"><div id="FPD_btnSave" style="width:80px;overflow:hidden;"></div></td>'
		+ '		         	<td align="center"><div id="FPD_btnMoveUp" style="width:80px;overflow:hidden;"></div></td>'
		+ '		         	<td align="center"><div id="FPD_btnMoveDown" style="width:80px;overflow:hidden;"></div></td>'
		+ '		         	<td align="center"><div id="FPD_btnFindICD" style="width:90px;overflow:hidden;"></div></td>'
		+ '		         	<td align="center"><div id="FPD_btnCopy" style="width:80px;overflow:hidden;"></div></td>'
		+ '		         	<td align="center"><div id="FPD_btnDelete" style="width:80px;overflow:hidden;"></div></td>'
		+ '		         	<td width="70%"></td>'
		+ '         </tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;">'
		+ '			<div style="width=100%;">'
		+ '				<span style="font-size:16px;"><b>手术、操作信息</b></span>&nbsp;&nbsp;&nbsp;&nbsp;'
		+ '     		<span onclick="objScreen.DivExpand(\'divOperation-DS\');" style="font-size:12px;color=red;">显示首页手术</span>'
		+ '			</div>'
		+ '		</td></tr>'
		+ '		<tr><td width="100%"><div id="divOperation-DS" style="width=100%;display:none;"></div></td></tr>'
		+ '		<tr><td width="100%"><div id="divOperation-FP" style="width=100%;"></div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '         <table><tr style="height:30px;">'
		+ '		         	<td align="center"><div id="FPO_btnSave" style="width:80px;overflow:hidden;"></div></td>'
		+ '		         	<td align="center"><div id="FPO_btnMoveUp" style="width:80px;overflow:hidden;"></div></td>'
		+ '		         	<td align="center"><div id="FPO_btnMoveDown" style="width:80px;overflow:hidden;"></div></td>'
		+ '		         	<td align="center"><div id="FPO_btnFindICD" style="width:90px;overflow:hidden;"></div></td>'
		+ '		         	<td align="center"><div id="FPO_btnCopy" style="width:80px;overflow:hidden;"></div></td>'
		+ '		         	<td align="center"><div id="FPO_btnDelete" style="width:80px;overflow:hidden;"></div></td>'
		+ '		         	<td width="70%"></td>'
		+ '         </tr></table>'
		+ '		</div></td></tr>'
		/* 
		+ '		<tr><td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;">'
		+ '			<div style="width=100%;">'
		+ '				<span style="font-size:16px;"><b>其他信息</b></span>&nbsp;&nbsp;&nbsp;&nbsp;'
		+ '     		<span onclick="objScreen.DivExpand(\'divExtraItem-DS\');" style="font-size:12px;color=red;">显示首页信息</span>'
		+ '			</div>'
		+ '		</td></tr>'
		+ '		<tr><td width="100%"><div id="divExtraItem-DS" style="width=100%;display:none;"></div></td></tr>'
		+ '		<tr><td width="100%"><div id="divExtraItem-FP" style="width=100%;"></div></td></tr>'
		 */
		 
		+ '		<tr><td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;">'
		+ '			<div style="width=100%;">'
		+ '				<span style="font-size:16px;"><b>附加信息</b></span>'
		+ '     	</div>'
		+ '		</td></tr>'
		+ '		<tr><td width="100%"><div id="divSubIfno-FP" style="width=100%;"></div></td></tr>'
		 
		+ '		<tr><td style="width=100%;height:3px;background-color:#84C1FF;"></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '         <table><tr style="height:40px;">'
		+ '		         	<td width="30%"></td>'
		+ '		         	<td align="center"><div id="btnSave" style="width:80px;overflow:hidden;"></div></td>'
		+ '		         	<td width="10%"></td>'
		+ '		         	<td align="center"><div id="btnSubmit" style="width:80px;overflow:hidden;"></div></td>'
		+ '		         	<td width="10%"></td>'
		+ '		         	<td align="center"><div id="btnClose" style="width:80px;overflow:hidden;"></div></td>'
		+ '		         	<td width="30%"></td>'
		+ '		    </tr></table>'
		+ '		</div></td></tr>'
		+ '</tr></table>'
		+ '</tr></td></table></div> '
	obj.MainPanel = new Ext.Panel({
		id : 'MainPanel'
		,autoScroll : true
		,frame : true
		,html : htmlMainPanel
		,title : '病案编目'
		,listeners: {
			render: function(p){
				p.body.on('keydown', function(e){
					if ((e.getKey()==e.UP)||(e.getKey()==e.DOWN)){
						e.stopEvent();  //屏蔽Panel上下键（上下键控制滚动条移动）
					}
				}, p);
			}
		}
	});
	
	obj.pnEpr = new Ext.Panel({
		title : '病历浏览',
		html : '<iframe id="ifEpr" width="100%" height="100%" src="#"/>'
	});
		
	obj.pnCost = new Ext.Panel({
		title : '费用信息',
		frame : true,
		autoScroll : true,
		html  :  obj.PatCost
	});
	
	obj.pnClose = new Ext.Panel({
		title : '<span style="color:red">关闭</span>'
	});
	
	obj.TabPanelList = new Ext.TabPanel({
		id : 'TabPanelList'
		,frame : true
		,activeTab : 0
		,items:[
			obj.MainPanel
			,obj.pnEpr
			,obj.pnCost
			,obj.pnClose
		]
	});
	
    obj.MainViewPort=new Ext.Viewport({
        id:'MainViewPortId'
        ,layout : 'fit'
		,items:[
			obj.TabPanelList
		]
    });
	
	obj.LoadEvent();
}

Ext.onReady(InitFrontPage);