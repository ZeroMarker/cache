
function InitViewPort()
{
	var obj = new Object();
	obj.ReportID=ReportID;
	
	var htmlMainPanel = ''
		+ '<table align="center" border=0 cellpadding=0 cellspacing=0>'
		
		+ '		<tr><td width="100%"><div style="width=100%;text-align:center;margin-bottom:20px;">'
		+ '		<span style="font-size:25px;color:#017BCE;"><b>郑州市城区疑似肺结核病人、肺结核病人转诊单</b></span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivBaseInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">患者姓名:</div></td><td><div id="TD-txtPatName" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">性别:</div></td><td><div id="TD-txtPatSex" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">年龄:</div></td><td><div id="TD-txtPatAge" class="TD-content"></div></td><td><div id="TD-Age">(周岁)</div></td>'
		+ '				<td><div class="TD-title">住院号:</div></td><td><div id="TD-txtPatMrNo" class="TD-content"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">现住址:</div></td><td><div id="TD-txtPatAddress" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">工作单位:</div></td><td><div id="TD-txtWorkAddress" class="TD-content"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">联系电话:</div></td><td><div id="TD-txtPatPhoneNo" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">户主姓名:</div></td><td><div id="TD-txtFamilyName" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">转诊原因:</div></td><td><div id="TD-cboReferralReason" class="TD-content"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">转诊单位:</div></td><td><div id="TD-txtReferralHosp" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">转诊医生:</div></td><td><div id="TD-txtReferralDoc" class="TD-content"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">转诊日期:</div></td><td><div id="TD-txtReferralDate" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">联系电话:</div></td><td><div id="TD-txtReferralPhone" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">地址:</div></td><td><div id="TD-txtReferralAdd" class="TD-content"></div></td>'
		+ '			</tr></table>'
		
		+ '</tr></table>'
	
	//
	obj.txtPatName=Common_TextField("txtPatName","患者姓名");
    obj.txtPatSex = Common_TextField("txtPatSex","性别");
	obj.txtPatAge = Common_TextField("txtPatAge","年龄");
	obj.txtPatMrNo = Common_TextField("txtPatMrNo","住院号");
	obj.txtPatAddress = Common_TextField("txtPatAddress","现住址");
	obj.txtPatPhoneNo = Common_TextField("txtPatPhoneNo","联系电话");
	obj.txtFamilyName = Common_TextField("txtFamilyName","户主姓名");
	
	obj.txtWorkAddress = Common_TextField("txtWorkAddress","工作单位");
	obj.cboReferralReason = Common_ComboToDic("cboReferralReason","转诊原因","ReferralReason");
	obj.txtReferralHosp = Common_TextField("txtReferralHosp","转诊单位");
	
	obj.txtReferralDoc = Common_TextField("txtReferralDoc","转诊医生");
	obj.txtReferralDate = Common_DateFieldToDate("txtReferralDate","转诊日期");
	obj.txtReferralAdd = Common_TextField("txtReferralAdd","转诊地址");
	obj.txtReferralPhone = Common_TextField("txtReferralPhone","转诊电话");
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,width : 75
		,text : '保存'
	});
	
	obj.btnCheck=new Ext.Button({
        id:'btnCheck'
        ,text:'审核'
        ,iconCls:'icon-save'
		,width : 75
    });
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,width : 75
		,text : '删除'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 75
		,text : '导出'
	});
	
	obj.btnPrint = new Ext.Button({
		id : 'btnPrint'
		,iconCls : 'icon-print'
		,width : 75
		,text : '打印'
	});
	
	obj.btnCancle=new Ext.Button({
        id:'btnCancle'
        ,text:'关闭'
        ,iconCls:'icon-exit'
		,width : 75
    });
	
	obj.MainPanel = new Ext.Panel({
		id : 'MainPanel'
		,autoScroll : true
		,frame : true
		,html : htmlMainPanel
		,buttonAlign:'center'
		,buttons : [
			obj.btnSave,
			obj.btnDelete,
			obj.btnCheck,
			obj.btnExport,
			obj.btnPrint,
			obj.btnCancle
		]
	});
	
	
	//鐣岄潰鏁翠綋甯冨眬
	obj.ViewPort = new Ext.Viewport({
		id:'MainViewPortId'
        ,layout : 'fit'
		,items:[
			obj.MainPanel
		]
	});
	
	Ext.ComponentMgr.all.each(function(cmp){
		var objTD = document.getElementById('TD-' + cmp.id);
		if (objTD) {
			cmp.setWidth(objTD.offsetWidth);
			cmp.render('TD-' + cmp.id);
		}
	});
	
	InitViewPortEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          