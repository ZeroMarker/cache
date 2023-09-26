function RVNP_InitReviewNotPass(VolumeID){
	var obj = new Object();
	obj.RVNP_VolumeID = VolumeID;
	
	obj.RVNP_chkDocSmt = new Ext.form.Checkbox({
		id : 'RVNP_chkDocSmt'
		,fieldLabel : '撤销医生提交'
		,height : 24
		,anchor : '100%'
	});
	
	obj.RVNP_chkNurSmt = new Ext.form.Checkbox({
		id : 'RVNP_chkNurSmt'
		,fieldLabel : '撤销护士提交'
		,height : 24
		,anchor : '100%'
	});
	
	obj.RVNP_txtResume = new Ext.form.TextArea({
		id : "RVNP_txtResume"
		,fieldLabel : "原因"
		,emptyText : '请说明原因...'
		,height : 50
		,maxLength : 200
		,anchor : '95%'
	});
	
	obj.RVNP_btnSave = new Ext.Button({
		id : 'RVNP_btnSave'
		,icon: '../scripts/dhcwmr/img/update.png'
		,text : '<span style="font-weight:bold;color:#457294;font-size:16;">确定</span>'
		,width : 80
	});
	
	obj.RVNP_btnCancel = new Ext.Button({
		id : 'RVNP_btnCancel'
		,icon: '../scripts/dhcwmr/img/remove.png'
		,text : '<span style="font-weight:bold;color:#457294;font-size:16;">关闭</span>'
		,width : 80
	});
	
	var htmlMainPanel = ''
		+ '<table align="center" border=0 cellpadding=0 cellspacing=0 style="border:0px solid #84C1FF;border-collapse:collapse;width:100%;">'
		+ '		<tr style="font-size:13px;height:30px;">'
		+ '			<td width="3%"><div id="cmp_RVNP_chkDocSmt" style="width=100%;display:block;"></div></td>'
		+ '			<td width="47%">撤销医生提交</td>'
		+ '			<td width="3%"><div id="cmp_RVNP_chkNurSmt" style="width=100%;display:block;"></div></td>'
		+ '			<td width="47%">撤销护士提交</td>'
		+ '		</tr>'
		+ '		<tr style="font-size:13px;height:30px;">'
		+ '			<td colspan=4><div id="cmp_RVNP_txtResume" style="width=100%;display:block;"></div></td>'
		+ '		</tr>'
		+ '		<tr><td colspan=4><div style="width=100%;">'
		+ '			<table><tr style="height:40px;">'
		+ '		         	<td width="40%"></td>'
		+ '		         	<td align="center"><div id="cmp_RVNP_btnSave" style="width:80px;overflow:hidden;"></div></td>'
		+ '		         	<td width="3%"></td>'
		+ '		         	<td align="center"><div id="cmp_RVNP_btnCancel" style="width:80px;overflow:hidden;"></div></td>'
		+ '		         	<td width="40%"></td>'
		+ '		    </tr></table>'
		+ '		</div></td></tr>'
		+ '</table>'
	
	obj.MainPanel = new Ext.Panel({
		id : 'MainPanel'
		,frame : true
		,html : htmlMainPanel
	});
	
	obj.RVNP_WinReviewNotPass = new Ext.Window({
		id : 'RVNP_WinReviewNotPass'
		,height : 180
		,width : 300
		,modal : true
		,title : '复核不通过'
		,closable : false
		,layout : 'fit'
		,resizable : false       //不可调整大小
		,draggable : false      //不可拖拽
		,items:[
			obj.MainPanel
		]
	});
	
	RVNP_InitReviewNotPassEvent(obj);
	obj.RVNP_LoadEvent(arguments);
	return obj;
}

