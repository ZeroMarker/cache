///Creator:caoting
///CreatDate:2014-04-24
///Descript:�������쵥
InRequestConWin=function(Fn,prolocid,prolocdesc){
	//var ProType=GetProTransType();
	var defaultData={
			RowId : prolocid,
			Description : prolocdesc
		};
	// ��������
	var RequestLoc = new Ext.ux.LocComboBox({
		fieldLabel : $g('������'),
		id : 'RequestLoc',
		name : 'RequestLoc',
		anchor : '90%',
		emptyText : $g('������...'),
		groupId:session['LOGON.GROUPID']
	});
	RequestLoc.on('select', function(e) {
	    Ext.getCmp("ProLoc").setValue("");
	    Ext.getCmp("ProLoc").setRawValue("");
	});
	var ProLoc = new Ext.ux.LocComboBox({
		fieldLabel : $g('��������'),
		id : 'ProLoc',
		name : 'ProLoc',
		anchor : '90%',
		emptyText : $g('��������...'),
		defaultLoc:defaultData,
		relid:Ext.getCmp("RequestLoc").getValue(),
		protype:'RF',
		params : {relid:'RequestLoc'}
			});



	// ��ʼ����
	var StartDate = new Ext.ux.EditDate({
		fieldLabel : $g('��ʼ����'),
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		value : DefaultStDate()
	});
	// ��ֹ����
	var EndDate = new Ext.ux.EditDate({
		fieldLabel : $g('��ֹ����'),
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		value : DefaultEdDate()
	});

	var UseDays =new Ext.form.NumberField({
		fieldLabel : $g('��ҩ����'),
		id : 'UseDays',
		name : 'UseDays',
		anchor : '90%'
	});
		// �б�
		var ZBFlag = new Ext.form.Radio({
		boxLabel : $g('�б�'),
		id : 'ZBFlag',
		name : 'ZBType',
		anchor : '80%'
	});
	// ���б�
	var NotZBFlag = new Ext.form.Radio({
		boxLabel : $g('���б�'),
		id : 'NotZBFlag',
		name : 'ZBType',
		anchor : '80%'
	});
	// ȫ��
	var AllFlag = new Ext.form.Radio({
		boxLabel : $g('ȫ��'),
		id : 'AllFlag',
		name : 'ZBType',
		anchor : '80%',
		checked : true
	});
	// ҩƷ����
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //��ʶ��������
		LocId:session['LOGON.CTLOCID'],
		UserId:session['LOGON.USERID'],
		anchor : '90%'
	}); 
	// ������
	var M_StkCat = new Ext.ux.ComboBox({
		fieldLabel : $g('������'),
		id : 'M_StkCat',
		name : 'M_StkCat',
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId:'StkGrpType'}
	});
	var PFlag = new Ext.form.Checkbox({
		boxLabel : $g('סԺ��ҩ'),
		id : 'PFlag',
		name : 'PFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : false
	});
	var YFlag = new Ext.form.Checkbox({
		boxLabel :$g( 'סԺ��ҩ'),
		id : 'YFlag',
		name : 'YFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : false
	});
	var FFlag = new Ext.form.Checkbox({
		boxLabel : $g('���﷢ҩ'),
		id : 'FFlag',
		name : 'FFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : false
	});
	var HFlag = new Ext.form.Checkbox({
		boxLabel : $g('������ҩ'),
		id : 'HFlag',
		name : 'HFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : false
	});
	var TFlag = new Ext.form.Checkbox({
		boxLabel : $g('ת��'),
		id : 'TFlag',
		name : 'TFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : false
	});
	var KFlag = new Ext.form.Checkbox({
		boxLabel : $g('ת��'),
		id : 'KFlag',
		name : 'KFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : false
	});

	// �رհ�ť
	var closeBT = new Ext.Toolbar.Button({
		text : $g('�ر�'),
		//tooltip : '����ر�',
		iconCls : 'page_close',
		handler : function() {
			window.close();
		}
	});

	// ȷ�ϰ�ť
	var sureBT = new Ext.Toolbar.Button({
		text : $g('ȷ��'),
		id:'sure',
		//tooltip : '���ȷ��',
		iconCls:'page_save',
		handler : function() {
			createInRequest();
		}
	})
	//����
  var mask = new Ext.LoadMask(Ext.getBody(), {
	  msg : $g('���Ժ� ... '),                           
	  removeMask : true
  }); 

  //�������뵥
  function createInRequest()
  { 
	var RequestLoc = Ext.getCmp("RequestLoc").getValue();   //�������
	var ProLoc = Ext.getCmp("ProLoc").getValue();  //��������
	var startDate = Ext.getCmp("StartDate").getRawValue(); //��ʼ����
	var endDate = Ext.getCmp("EndDate").getRawValue();     //��������
	var UseDays = Ext.getCmp("UseDays").getValue();   //�ο�����

	if((UseDays=="")||(UseDays==null)||(UseDays<=0)){
		Msg.info("warning", $g("����д��ȷ��ҩ����!"));
		return false;
	}
	if((ProLoc=="")||(ProLoc==null)){
		Msg.info("warning", $g("��ѡ�񹩸�����!"));
		return false;
	}
	if (RequestLoc == undefined || RequestLoc.length <= 0) {
		Msg.info("warning", $g("��ѡ��������!"));
		return;
	}
	if (ProLoc==RequestLoc){
		Msg.info("warning", $g("���������������Ų�����ͬ!"));
		return;
	}
	if (startDate == undefined || startDate.length <= 0) {
		Msg.info("warning", $g("��ѡ��ʼ����!"));
		return;
	}
	if (endDate == undefined || endDate.length <= 0) {
		Msg.info("warning", $g("��ѡ���ֹ����!"));
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
		Msg.info("warning", $g("��ѡ��ҵ������!"));
		return;
	}
	//if(ConsumeLoc==""){ConsumeLoc=RequestLoc;}  //���Ŀ���Ϊѡ��Ĭ�ϲɹ�����
	var status=""
	var StrParam=ProLoc+"^"+startDate+"^"+endDate+"^"+UseDays+"^"+stkgrp+"^"+TransType+"^"+RequestLoc;
	StrParam=StrParam+"^"+session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+status;
	mask.show(); //�ڸ�
	//�������쵥
	Ext.Ajax.request({
		url: DictUrl+'inrequestaction.csp?actiontype=CreateInRequest',
		params:{strParam:StrParam},
		failure: function(result, request) {
			Msg.info("error",$g("������������!"));
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				window.close();
				Msg.info("success",$g("����ɹ�!"));
				mask.hide(); //�ڸ�����
				inqId=jsonData.info;
				Fn(inqId);
				//location.href="dhcst.inpurplan.csp?planNnmber="+jsonData.info+'&locId='+locId;
			}else{
				if(jsonData.info==""){
					Msg.info("error",$g("���һ���ԱΪ��!"));
				}else if(jsonData.info=="-1"){
					Msg.info("warning",$g("������Χ���޿�������!"));
				}
				else{
					Msg.info("error",$g("����ʧ��!"));
				}
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
				title : $g('��������'),
				autoHeight : true,
				items : [{
					layout : 'column',
					height:25,
					items : [ 
						{columnWidth:.4,layout:'form',items:[StartDate]},
						{columnWidth:.6,layout:'form',items:[RequestLoc]}
					]
			    },{
				    layout : 'column',
				    height:25,
				    items : [
					   {columnWidth:.4,layout:'form',items:[EndDate]},
					   {columnWidth:.6,layout:'form',items:[ProLoc]}
				    ]
			   },{
				    layout : 'column',
				    height:25,
				    items : [
					   {columnWidth:.4,layout:'form',items:[UseDays]},
					   {columnWidth:.6,layout:'form',items:[StkGrpType]}
				    ]
			   }]
			},{
				xtype : 'fieldset',
				title : $g('ҵ������'),
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
		title:$g('���տ��ҿ���������뵥'),
		width:document.body.clientWidth * 0.5,
		height:330,
		modal:true,
		resizable:false,
		items:vendorPanel,
		bbar:[sureBT,'-',closeBT]
	})
	window.show();
	// ��ʼ������
	CopyComboBoxStore({frombox:"LocField",tobox:"RequestLoc"});
	CopyComboBoxStore({frombox:"supplyLocField",tobox:"ProLoc"});
	CopyComboBoxStore({frombox:"groupField",tobox:"StkGrpType"});
}