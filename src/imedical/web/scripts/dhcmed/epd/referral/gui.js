
function InitViewPort()
{
	var obj = new Object();
	obj.ReportID=ReportID;
	
	var htmlMainPanel = ''
		+ '<table align="center" border=0 cellpadding=0 cellspacing=0>'
		
		+ '		<tr><td width="100%"><div style="width=100%;text-align:center;margin-bottom:20px;">'
		+ '		<span style="font-size:25px;color:#017BCE;"><b>֣���г������Ʒν�˲��ˡ��ν�˲���ת�ﵥ</b></span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivBaseInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">��������:</div></td><td><div id="TD-txtPatName" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">�Ա�:</div></td><td><div id="TD-txtPatSex" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">����:</div></td><td><div id="TD-txtPatAge" class="TD-content"></div></td><td><div id="TD-Age">(����)</div></td>'
		+ '				<td><div class="TD-title">סԺ��:</div></td><td><div id="TD-txtPatMrNo" class="TD-content"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">��סַ:</div></td><td><div id="TD-txtPatAddress" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">������λ:</div></td><td><div id="TD-txtWorkAddress" class="TD-content"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">��ϵ�绰:</div></td><td><div id="TD-txtPatPhoneNo" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">��������:</div></td><td><div id="TD-txtFamilyName" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">ת��ԭ��:</div></td><td><div id="TD-cboReferralReason" class="TD-content"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">ת�ﵥλ:</div></td><td><div id="TD-txtReferralHosp" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">ת��ҽ��:</div></td><td><div id="TD-txtReferralDoc" class="TD-content"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">ת������:</div></td><td><div id="TD-txtReferralDate" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">��ϵ�绰:</div></td><td><div id="TD-txtReferralPhone" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">��ַ:</div></td><td><div id="TD-txtReferralAdd" class="TD-content"></div></td>'
		+ '			</tr></table>'
		
		+ '</tr></table>'
	
	//
	obj.txtPatName=Common_TextField("txtPatName","��������");
    obj.txtPatSex = Common_TextField("txtPatSex","�Ա�");
	obj.txtPatAge = Common_TextField("txtPatAge","����");
	obj.txtPatMrNo = Common_TextField("txtPatMrNo","סԺ��");
	obj.txtPatAddress = Common_TextField("txtPatAddress","��סַ");
	obj.txtPatPhoneNo = Common_TextField("txtPatPhoneNo","��ϵ�绰");
	obj.txtFamilyName = Common_TextField("txtFamilyName","��������");
	
	obj.txtWorkAddress = Common_TextField("txtWorkAddress","������λ");
	obj.cboReferralReason = Common_ComboToDic("cboReferralReason","ת��ԭ��","ReferralReason");
	obj.txtReferralHosp = Common_TextField("txtReferralHosp","ת�ﵥλ");
	
	obj.txtReferralDoc = Common_TextField("txtReferralDoc","ת��ҽ��");
	obj.txtReferralDate = Common_DateFieldToDate("txtReferralDate","ת������");
	obj.txtReferralAdd = Common_TextField("txtReferralAdd","ת���ַ");
	obj.txtReferralPhone = Common_TextField("txtReferralPhone","ת��绰");
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,width : 75
		,text : '����'
	});
	
	obj.btnCheck=new Ext.Button({
        id:'btnCheck'
        ,text:'���'
        ,iconCls:'icon-save'
		,width : 75
    });
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,width : 75
		,text : 'ɾ��'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 75
		,text : '����'
	});
	
	obj.btnPrint = new Ext.Button({
		id : 'btnPrint'
		,iconCls : 'icon-print'
		,width : 75
		,text : '��ӡ'
	});
	
	obj.btnCancle=new Ext.Button({
        id:'btnCancle'
        ,text:'�ر�'
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
	
	
	//界面整体布局
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
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          