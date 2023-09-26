///Creator:ws
///CreatDate:2020-02-26
///Descript:�Զ�����������
CreatLimtsConWin=function(Fn){
	//var ProType=GetProTransType();
	
	var gUserId=session['LOGON.USERID']
	var gGroupId=session['LOGON.GROUPID'];  
    var gLocId=session['LOGON.CTLOCID'];
	var curLoc = new Ext.ux.LocComboBox({
		fieldLabel : '����',
		id : 'curLoc',
		name : 'curLoc',
		anchor : '90%',
		emptyText : '����...',
		groupId:session['LOGON.GROUPID'],
        listeners : {
			'select' : function(e) {
                          var SelLocId=Ext.getCmp('curLoc').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
                          StkGrpTypel.getStore().removeAll();
                          StkGrpTypel.getStore().setBaseParam("locId",SelLocId)
                          StkGrpTypel.getStore().setBaseParam("userId",gUserId)
                          StkGrpTypel.getStore().setBaseParam("type",App_StkTypeCode)
                          StkGrpTypel.getStore().load();
			}
	    }
	});
	

	// ��ʼ����
	var StartDate = new Ext.ux.EditDate({
		fieldLabel : '��ʼ����',
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		value:DefaultStDate()
	});
	// ��ֹ����
	var EndDate = new Ext.ux.EditDate({
		fieldLabel : '��ֹ����',
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		value:DefaultEdDate()
	});

	var maxlimts =new Ext.form.NumberField({
		fieldLabel : '����ϵ��',
		id : 'maxlimts',
		name : 'maxlimts',
		anchor : '90%',
		value:1.25
	});
	var minlimts =new Ext.form.NumberField({
		fieldLabel : '����ϵ��',
		id : 'minlimts',
		name : 'minlimts',
		anchor : '90%',
		value:0.25
	});	
	var AllFlag = new Ext.form.Radio({
		boxLabel : 'ȫ��',
		id : 'AllFlag',
		name : 'ZBType',
		anchor : '80%',
		checked : true
	});
	
	// ҩƷ����
	var StkGrpTypel=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpTypel',
		name : 'StkGrpTypel',
		StkType:App_StkTypeCode,     //��ʶ��������
		UserId:gUserId,
        LocId:gLocId,
		UserId:session['LOGON.USERID'],
		anchor : '90%'
	}); 
	
	var PFlag = new Ext.form.Checkbox({
		boxLabel : 'סԺ��ҩ',
		id : 'PFlag',
		name : 'PFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : true
	});
	var YFlag = new Ext.form.Checkbox({
		boxLabel : 'סԺ��ҩ',
		id : 'YFlag',
		name : 'YFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : true
	});
	var FFlag = new Ext.form.Checkbox({
		boxLabel : '���﷢ҩ',
		id : 'FFlag',
		name : 'FFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : true
	});
	var HFlag = new Ext.form.Checkbox({
		boxLabel : '������ҩ',
		id : 'HFlag',
		name : 'HFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : true
	});
	var TFlag = new Ext.form.Checkbox({
		boxLabel : 'ת��',
		id : 'TFlag',
		name : 'TFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : false
	});
	var KFlag = new Ext.form.Checkbox({
		boxLabel : 'ת��',
		id : 'KFlag',
		name : 'KFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : false
	});

	// �رհ�ť
	var closeBT = new Ext.Toolbar.Button({
		text : '�ر�',
		//tooltip : '����ر�',
		iconCls : 'page_close',
		handler : function() {
			window.close();
		}
	});

	// ȷ�ϰ�ť
	var sureBT = new Ext.Toolbar.Button({
		text : 'ȷ��',
		id:'sure',
		//tooltip : '���ȷ��',
		iconCls:'page_save',
		handler : function() {
			createlimits();
		}
	})
	//����
  var mask = new Ext.LoadMask(Ext.getBody(), {
	  msg : '���Ժ� ... ',                           
	  removeMask : true
  }); 

  //�������뵥
  function createlimits()
  { 
	var curloc =Ext.getCmp("curLoc").getValue();  
	var startDate = Ext.getCmp("StartDate").getRawValue(); //��ʼ����
	var endDate = Ext.getCmp("EndDate").getRawValue();     //��������
	var maxlimt =Ext.getCmp("maxlimts").getValue();   //����ϵ��
	var minlimt=Ext.getCmp("minlimts").getValue();   //����ϵ��

	if((maxlimt=="")||(maxlimt==null)||(maxlimt<=0)){
		Msg.info("warning", "����д��ȷ����ϵ��!");
		return false;
	}
	if((minlimt=="")||(minlimt==null)||(minlimt<=0)){
		Msg.info("warning", "����д��ȷ����ϵ��!");
		return false;
	}
	
	if(minlimt>maxlimt){
		Msg.info("warning", "����ϵ������С������ϵ��!");
		return false;
	}
	
	if((curloc=="")||(curloc==null)){
		Msg.info("warning", "��ѡ����!");
		return false;
	}
	
	if (startDate == undefined || startDate.length <= 0) {
		Msg.info("warning", "��ѡ��ʼ����!");
		return;
	}
	if (endDate == undefined || endDate.length <= 0) {
		Msg.info("warning", "��ѡ���ֹ����!");
		return;
	}

	var stkgrp=Ext.getCmp("StkGrpType").getValue();
 
	//ҵ������
	var TransType='';
	var PFlag=(Ext.getCmp("PFlag").getValue()==true?'P':'');
	var YFlag=(Ext.getCmp("YFlag").getValue()==true?'Y':'');
	var FFlag=(Ext.getCmp("FFlag").getValue()==true?'F':'');
	var HFlag=(Ext.getCmp("HFlag").getValue()==true?'H':'');
	var TFlag=(Ext.getCmp("TFlag").getValue()==true?'T':'');
	var KFlag=(Ext.getCmp("KFlag").getValue()==true?'K':'');
	if(PFlag!=''){
		if(TransType!=''){
			TransType=TransType+','+PFlag;
		}else{
			TransType=PFlag;
		}
	}
	if(YFlag!=''){
		if(TransType!=''){
			TransType=TransType+','+YFlag;
		}else{
			TransType=YFlag;
		}
	}
	if(FFlag!=''){
		if(TransType!=''){
			TransType=TransType+','+FFlag;
		}else{
			TransType=FFlag;
		}
	}
	if(HFlag!=''){
		if(TransType!=''){
			TransType=TransType+','+HFlag;
		}else{
			TransType=HFlag;
		}
	}
	if(TFlag!=''){
		if(TransType!=''){
			TransType=TransType+','+TFlag;
		}else{
			TransType=TFlag;
		}
	}
	if(KFlag!=''){
		if(TransType!=''){
			TransType=TransType+','+KFlag;
		}else{
			TransType=KFlag;
		}
	}
	if (TransType == null || TransType.length <= 0) {
		Msg.info("warning", "��ѡ��ҵ������!");
		return;
	}
	
	var status=""
	var StrParam=curloc+"^"+startDate+"^"+endDate+"^"+maxlimt+"^"+minlimt+"^"+stkgrp+"^"+TransType;
	
	mask.show(); //�ڸ�
	//����������
	 var url = DictUrl+ "incitmlocaction.csp?actiontype=CreatLimts";
	 
	Ext.Ajax.request({
		url: url,
		params:{strParam:StrParam},
		failure: function(result, request) {
			Msg.info("error","������������!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				window.close();
				Msg.info("success","����ɹ�!");
				mask.hide(); //�ڸ�����
				
				Fn();
				//location.href="dhcst.inpurplan.csp?planNnmber="+jsonData.info+'&locId='+locId;
			}else{
				
					Msg.info("error","����ʧ��!");
				
				mask.hide(); //�ڸ�����
			}
		},
		scope: this
	});
  }
  
		//��ʼ�����
	var vendorPanel = new Ext.form.FormPanel({
		labelWidth :70,
		labelAlign : 'right',
		frame : true,
		//autoScroll : true,
		bodyStyle : 'padding:1px;',
		items : [{
			autoHeight : true,
			items : [{
				xtype : 'fieldset',
				title : '����',
				autoHeight : true,
				items : [{
					layout : 'column',
					height:25,
					items : [ 
						{columnWidth:.4,layout:'form',items:[StartDate]},
						{columnWidth:.6,layout:'form',items:[curLoc]}
					]
			    },{
				    layout : 'column',
				    height:25,
				    items : [
					   {columnWidth:.4,layout:'form',items:[EndDate]},
					   {columnWidth:.6,layout:'form',items:[StkGrpTypel]}
				    ]
			   },{
				    layout : 'column',
				    height:25,
				    items : [
					   {columnWidth:.4,layout:'form',items:[maxlimts]},
					   {columnWidth:.6,layout:'form',items:[minlimts]}
				    ]
			   }]
			},{
				xtype : 'fieldset',
				title : 'ҵ������',
				autoHeight : true,
				items : [{
					layout:'column',
					height:25,
					items : [
						{columnWidth:.5,layout:'form',items:[PFlag]},
						{columnWidth:.5,layout:'form',items:[YFlag]}
					]
				},{
					layout:'column',
					height:25,
					items : [
						{columnWidth:.5,layout:'form',items:[FFlag]},
						{columnWidth:.5,layout:'form',items:[HFlag]}
					]
				},{
					layout:'column',
					height:25,
					items : [
						{columnWidth:.5,layout:'form',items:[TFlag]},
						{columnWidth:.5,layout:'form',items:[KFlag]}
					]
				}]
			}]
		}]
	})

	var window=new Ext.Window({
		title:'����ϵ������������',
		width:document.body.clientWidth * 0.5,
		height:330,
		modal:true,
		resizable:false,
		items:vendorPanel,
		bbar:[sureBT,'-',closeBT]
	})
	function DefaultStDate(){
	
	var today=new Date();
	var defaStDate=-35;
	var StDate=today.add(Date.DAY, parseInt(defaStDate));
	StDate=StDate.format(App_StkDateFormat);
	return StDate;		
}

/*
 * creator:zhangdongmei,2012-10-17
 * description:ȡĬ�ϵĽ�ֹ����
 * params: 
 * return:��ֹ����
 * */
function DefaultEdDate(){
	
	var today=new Date();
	

	var defaEdDate=-1;
	
	var EdDate=today.add(Date.DAY, parseInt(defaEdDate));
	EdDate=EdDate.format(App_StkDateFormat);
	return EdDate;
}
	window.show();
	// ��ʼ������
	//CopyComboBoxStore({frombox:"LocField",tobox:"curLoc"});
	//CopyComboBoxStore({frombox:"StkGrpType",tobox:"StkGrpTypel"});
}