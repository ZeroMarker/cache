///Creator:ws
///CreatDate:2020-02-26
///Descript:自动生成上下限
CreatLimtsConWin=function(Fn){
	//var ProType=GetProTransType();
	
	var gUserId=session['LOGON.USERID']
	var gGroupId=session['LOGON.GROUPID'];  
    var gLocId=session['LOGON.CTLOCID'];
	var curLoc = new Ext.ux.LocComboBox({
		fieldLabel : '科室',
		id : 'curLoc',
		name : 'curLoc',
		anchor : '90%',
		emptyText : '科室...',
		groupId:session['LOGON.GROUPID'],
        listeners : {
			'select' : function(e) {
                          var SelLocId=Ext.getCmp('curLoc').getValue();//add wyx 根据选择的科室动态加载类组
                          StkGrpTypel.getStore().removeAll();
                          StkGrpTypel.getStore().setBaseParam("locId",SelLocId)
                          StkGrpTypel.getStore().setBaseParam("userId",gUserId)
                          StkGrpTypel.getStore().setBaseParam("type",App_StkTypeCode)
                          StkGrpTypel.getStore().load();
			}
	    }
	});
	

	// 起始日期
	var StartDate = new Ext.ux.EditDate({
		fieldLabel : '起始日期',
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		value:DefaultStDate()
	});
	// 截止日期
	var EndDate = new Ext.ux.EditDate({
		fieldLabel : '截止日期',
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		value:DefaultEdDate()
	});

	var maxlimts =new Ext.form.NumberField({
		fieldLabel : '上限系数',
		id : 'maxlimts',
		name : 'maxlimts',
		anchor : '90%',
		value:1.25
	});
	var minlimts =new Ext.form.NumberField({
		fieldLabel : '下限系数',
		id : 'minlimts',
		name : 'minlimts',
		anchor : '90%',
		value:0.25
	});	
	var AllFlag = new Ext.form.Radio({
		boxLabel : '全部',
		id : 'AllFlag',
		name : 'ZBType',
		anchor : '80%',
		checked : true
	});
	
	// 药品类组
	var StkGrpTypel=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpTypel',
		name : 'StkGrpTypel',
		StkType:App_StkTypeCode,     //标识类组类型
		UserId:gUserId,
        LocId:gLocId,
		UserId:session['LOGON.USERID'],
		anchor : '90%'
	}); 
	
	var PFlag = new Ext.form.Checkbox({
		boxLabel : '住院发药',
		id : 'PFlag',
		name : 'PFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : true
	});
	var YFlag = new Ext.form.Checkbox({
		boxLabel : '住院退药',
		id : 'YFlag',
		name : 'YFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : true
	});
	var FFlag = new Ext.form.Checkbox({
		boxLabel : '门诊发药',
		id : 'FFlag',
		name : 'FFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : true
	});
	var HFlag = new Ext.form.Checkbox({
		boxLabel : '门诊退药',
		id : 'HFlag',
		name : 'HFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : true
	});
	var TFlag = new Ext.form.Checkbox({
		boxLabel : '转出',
		id : 'TFlag',
		name : 'TFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : false
	});
	var KFlag = new Ext.form.Checkbox({
		boxLabel : '转入',
		id : 'KFlag',
		name : 'KFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : false
	});

	// 关闭按钮
	var closeBT = new Ext.Toolbar.Button({
		text : '关闭',
		//tooltip : '点击关闭',
		iconCls : 'page_close',
		handler : function() {
			window.close();
		}
	});

	// 确认按钮
	var sureBT = new Ext.Toolbar.Button({
		text : '确认',
		id:'sure',
		//tooltip : '点击确认',
		iconCls:'page_save',
		handler : function() {
			createlimits();
		}
	})
	//遮罩
  var mask = new Ext.LoadMask(Ext.getBody(), {
	  msg : '请稍后 ... ',                           
	  removeMask : true
  }); 

  //创建申请单
  function createlimits()
  { 
	var curloc =Ext.getCmp("curLoc").getValue();  
	var startDate = Ext.getCmp("StartDate").getRawValue(); //起始日期
	var endDate = Ext.getCmp("EndDate").getRawValue();     //结束日期
	var maxlimt =Ext.getCmp("maxlimts").getValue();   //上限系数
	var minlimt=Ext.getCmp("minlimts").getValue();   //下限系数

	if((maxlimt=="")||(maxlimt==null)||(maxlimt<=0)){
		Msg.info("warning", "请填写正确上限系数!");
		return false;
	}
	if((minlimt=="")||(minlimt==null)||(minlimt<=0)){
		Msg.info("warning", "请填写正确下限系数!");
		return false;
	}
	
	if(minlimt>maxlimt){
		Msg.info("warning", "上限系数不能小于下限系数!");
		return false;
	}
	
	if((curloc=="")||(curloc==null)){
		Msg.info("warning", "请选科室!");
		return false;
	}
	
	if (startDate == undefined || startDate.length <= 0) {
		Msg.info("warning", "请选择开始日期!");
		return;
	}
	if (endDate == undefined || endDate.length <= 0) {
		Msg.info("warning", "请选择截止日期!");
		return;
	}

	var stkgrp=Ext.getCmp("StkGrpType").getValue();
 
	//业务类型
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
		Msg.info("warning", "请选择业务类型!");
		return;
	}
	
	var status=""
	var StrParam=curloc+"^"+startDate+"^"+endDate+"^"+maxlimt+"^"+minlimt+"^"+stkgrp+"^"+TransType;
	
	mask.show(); //遮盖
	//生成上下限
	 var url = DictUrl+ "incitmlocaction.csp?actiontype=CreatLimts";
	 
	Ext.Ajax.request({
		url: url,
		params:{strParam:StrParam},
		failure: function(result, request) {
			Msg.info("error","请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				window.close();
				Msg.info("success","保存成功!");
				mask.hide(); //遮盖隐藏
				
				Fn();
				//location.href="dhcst.inpurplan.csp?planNnmber="+jsonData.info+'&locId='+locId;
			}else{
				
					Msg.info("error","保存失败!");
				
				mask.hide(); //遮盖隐藏
			}
		},
		scope: this
	});
  }
  
		//初始化面板
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
				title : '因子',
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
				title : '业务类型',
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
		title:'按照系数生成上下限',
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
 * description:取默认的截止日期
 * params: 
 * return:截止日期
 * */
function DefaultEdDate(){
	
	var today=new Date();
	

	var defaEdDate=-1;
	
	var EdDate=today.add(Date.DAY, parseInt(defaEdDate));
	EdDate=EdDate.format(App_StkDateFormat);
	return EdDate;
}
	window.show();
	// 初始化下拉
	//CopyComboBoxStore({frombox:"LocField",tobox:"curLoc"});
	//CopyComboBoxStore({frombox:"StkGrpType",tobox:"StkGrpTypel"});
}