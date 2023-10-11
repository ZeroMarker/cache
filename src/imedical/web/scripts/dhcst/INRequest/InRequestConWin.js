///Creator:caoting
///CreatDate:2014-04-24
///Descript:创建申领单
InRequestConWin=function(Fn,prolocid,prolocdesc){
	//var ProType=GetProTransType();
	var defaultData={
			RowId : prolocid,
			Description : prolocdesc
		};
	// 订购部门
	var RequestLoc = new Ext.ux.LocComboBox({
		fieldLabel : $g('请求部门'),
		id : 'RequestLoc',
		name : 'RequestLoc',
		anchor : '90%',
		emptyText : $g('请求部门...'),
		groupId:session['LOGON.GROUPID']
	});
	RequestLoc.on('select', function(e) {
	    Ext.getCmp("ProLoc").setValue("");
	    Ext.getCmp("ProLoc").setRawValue("");
	});
	var ProLoc = new Ext.ux.LocComboBox({
		fieldLabel : $g('供给科室'),
		id : 'ProLoc',
		name : 'ProLoc',
		anchor : '90%',
		emptyText : $g('供给科室...'),
		defaultLoc:defaultData,
		relid:Ext.getCmp("RequestLoc").getValue(),
		protype:'RF',
		params : {relid:'RequestLoc'}
			});



	// 起始日期
	var StartDate = new Ext.ux.EditDate({
		fieldLabel : $g('起始日期'),
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		value : DefaultStDate()
	});
	// 截止日期
	var EndDate = new Ext.ux.EditDate({
		fieldLabel : $g('截止日期'),
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		value : DefaultEdDate()
	});

	var UseDays =new Ext.form.NumberField({
		fieldLabel : $g('用药天数'),
		id : 'UseDays',
		name : 'UseDays',
		anchor : '90%'
	});
		// 招标
		var ZBFlag = new Ext.form.Radio({
		boxLabel : $g('招标'),
		id : 'ZBFlag',
		name : 'ZBType',
		anchor : '80%'
	});
	// 非招标
	var NotZBFlag = new Ext.form.Radio({
		boxLabel : $g('非招标'),
		id : 'NotZBFlag',
		name : 'ZBType',
		anchor : '80%'
	});
	// 全部
	var AllFlag = new Ext.form.Radio({
		boxLabel : $g('全部'),
		id : 'AllFlag',
		name : 'ZBType',
		anchor : '80%',
		checked : true
	});
	// 药品类组
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //标识类组类型
		LocId:session['LOGON.CTLOCID'],
		UserId:session['LOGON.USERID'],
		anchor : '90%'
	}); 
	// 库存分类
	var M_StkCat = new Ext.ux.ComboBox({
		fieldLabel : $g('库存分类'),
		id : 'M_StkCat',
		name : 'M_StkCat',
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId:'StkGrpType'}
	});
	var PFlag = new Ext.form.Checkbox({
		boxLabel : $g('住院发药'),
		id : 'PFlag',
		name : 'PFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : false
	});
	var YFlag = new Ext.form.Checkbox({
		boxLabel :$g( '住院退药'),
		id : 'YFlag',
		name : 'YFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : false
	});
	var FFlag = new Ext.form.Checkbox({
		boxLabel : $g('门诊发药'),
		id : 'FFlag',
		name : 'FFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : false
	});
	var HFlag = new Ext.form.Checkbox({
		boxLabel : $g('门诊退药'),
		id : 'HFlag',
		name : 'HFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : false
	});
	var TFlag = new Ext.form.Checkbox({
		boxLabel : $g('转出'),
		id : 'TFlag',
		name : 'TFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : false
	});
	var KFlag = new Ext.form.Checkbox({
		boxLabel : $g('转入'),
		id : 'KFlag',
		name : 'KFlag',
		anchor : '90%',
		width : 50 , 
		height : 30 ,
		checked : false
	});

	// 关闭按钮
	var closeBT = new Ext.Toolbar.Button({
		text : $g('关闭'),
		//tooltip : '点击关闭',
		iconCls : 'page_close',
		handler : function() {
			window.close();
		}
	});

	// 确认按钮
	var sureBT = new Ext.Toolbar.Button({
		text : $g('确认'),
		id:'sure',
		//tooltip : '点击确认',
		iconCls:'page_save',
		handler : function() {
			createInRequest();
		}
	})
	//遮罩
  var mask = new Ext.LoadMask(Ext.getBody(), {
	  msg : $g('请稍后 ... '),                           
	  removeMask : true
  }); 

  //创建申请单
  function createInRequest()
  { 
	var RequestLoc = Ext.getCmp("RequestLoc").getValue();   //申领科室
	var ProLoc = Ext.getCmp("ProLoc").getValue();  //供给科室
	var startDate = Ext.getCmp("StartDate").getRawValue(); //起始日期
	var endDate = Ext.getCmp("EndDate").getRawValue();     //结束日期
	var UseDays = Ext.getCmp("UseDays").getValue();   //参考天数

	if((UseDays=="")||(UseDays==null)||(UseDays<=0)){
		Msg.info("warning", $g("请填写正确用药天数!"));
		return false;
	}
	if((ProLoc=="")||(ProLoc==null)){
		Msg.info("warning", $g("请选择供给部门!"));
		return false;
	}
	if (RequestLoc == undefined || RequestLoc.length <= 0) {
		Msg.info("warning", $g("请选择请求部门!"));
		return;
	}
	if (ProLoc==RequestLoc){
		Msg.info("warning", $g("供给部门与请求部门不能相同!"));
		return;
	}
	if (startDate == undefined || startDate.length <= 0) {
		Msg.info("warning", $g("请选择开始日期!"));
		return;
	}
	if (endDate == undefined || endDate.length <= 0) {
		Msg.info("warning", $g("请选择截止日期!"));
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
		Msg.info("warning", $g("请选择业务类型!"));
		return;
	}
	//if(ConsumeLoc==""){ConsumeLoc=RequestLoc;}  //消耗科室为选择默认采购科室
	var status=""
	var StrParam=ProLoc+"^"+startDate+"^"+endDate+"^"+UseDays+"^"+stkgrp+"^"+TransType+"^"+RequestLoc;
	StrParam=StrParam+"^"+session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+status;
	mask.show(); //遮盖
	//生成申领单
	Ext.Ajax.request({
		url: DictUrl+'inrequestaction.csp?actiontype=CreateInRequest',
		params:{strParam:StrParam},
		failure: function(result, request) {
			Msg.info("error",$g("请检查网络连接!"));
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				window.close();
				Msg.info("success",$g("保存成功!"));
				mask.hide(); //遮盖隐藏
				inqId=jsonData.info;
				Fn(inqId);
				//location.href="dhcst.inpurplan.csp?planNnmber="+jsonData.info+'&locId='+locId;
			}else{
				if(jsonData.info==""){
					Msg.info("error",$g("科室或人员为空!"));
				}else if(jsonData.info=="-1"){
					Msg.info("warning",$g("条件范围内无可用数据!"));
				}
				else{
					Msg.info("error",$g("保存失败!"));
				}
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
				title : $g('请求因子'),
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
				title : $g('业务类型'),
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
		title:$g('按照科室库存生成申请单'),
		width:document.body.clientWidth * 0.5,
		height:330,
		modal:true,
		resizable:false,
		items:vendorPanel,
		bbar:[sureBT,'-',closeBT]
	})
	window.show();
	// 初始化下拉
	CopyComboBoxStore({frombox:"LocField",tobox:"RequestLoc"});
	CopyComboBoxStore({frombox:"supplyLocField",tobox:"ProLoc"});
	CopyComboBoxStore({frombox:"groupField",tobox:"StkGrpType"});
}