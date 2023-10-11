	///Creator:bianshuai
	///CreatDate:2014-04-24
	///Descript:创建采购计划单
	InPurPlanConWin=function(Fn){
		var ConsumeLoc = new Ext.ux.LocComboBox({
			fieldLabel : $g('消耗科室'),
			id : 'ConsumeLoc',
			name : 'ConsumeLoc',
			anchor : '90%',
			emptyText : $g('消耗科室...'),
			defaultLoc:""
		});

		// 订购部门
		var PurLoc = new Ext.ux.LocComboBox({
			fieldLabel : $g('采购部门'),
			id : 'PurLoc',
			name : 'PurLoc',
			anchor : '90%',
			emptyText : $g('采购部门...'),
			groupId:session['LOGON.GROUPID'],
			listeners : {
			'select' : function(e) {
                          var PurLoc=Ext.getCmp('PurLoc').getValue();//add wyx 根据选择的科室动态加载类组
                          StkGrpType.getStore().removeAll();
                          StkGrpType.getStore().setBaseParam("locId",PurLoc)
                          StkGrpType.getStore().setBaseParam("userId",UserId)
                          StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
                          StkGrpType.getStore().load();
				}
		}
		});
		// 起始日期
		var StartDate = new Ext.ux.DateField({
			fieldLabel : $g('起始日期'),
			id : 'StartDate',
			name : 'StartDate',
			anchor : '90%',
			value : DefaultStDate()
		});
		// 截止日期
		var EndDate = new Ext.ux.DateField({
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
		StkGrpType.on('select',function(){
		Ext.getCmp("M_StkCat").setValue("");
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
			height : 30 ,
			//width : 80,
			checked : false
		});
		var YFlag = new Ext.form.Checkbox({
			boxLabel : $g('住院退药'),
			id : 'YFlag',
			name : 'YFlag',
			anchor : '90%',
			height : 30 ,
			//width : 80,
			checked : false
		});
		var FFlag = new Ext.form.Checkbox({
			boxLabel : $g('门诊发药'),
			id : 'FFlag',
			name : 'FFlag',
			anchor : '90%',
			height : 30 ,
			//width : 80,
			checked : false
		});
		var HFlag = new Ext.form.Checkbox({
			boxLabel : $g('门诊退药'),
			id : 'HFlag',
			name : 'HFlag',
			anchor : '90%',
			height : 30 ,
			//width : 80,
			checked : false
		});
		var TFlag = new Ext.form.Checkbox({
			boxLabel : $g('转出'),
			id : 'TFlag',
			name : 'TFlag',
			anchor : '90%',
			height : 30 ,
			//width : 80,
			checked : false
		});
		var KFlag = new Ext.form.Checkbox({
			boxLabel : $g('转入'),
			id : 'KFlag',
			name : 'KFlag',
			anchor : '90%',
			height : 30 ,
			//width : 80,
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
				createInPurPlan();
			}
		})
		//遮罩
	  var mask = new Ext.LoadMask(Ext.getBody(), {
		  msg : $g('请稍后 ... '),                           
		  removeMask : true
	  }); 

  	  //创建采购计划单
	  function createInPurPlan()
	  { 
		var PurLoc = Ext.getCmp("PurLoc").getValue();   //采购科室
		var ConsumeLoc = Ext.getCmp("ConsumeLoc").getValue();  //消耗科室
		var startDate = Ext.getCmp("StartDate").getRawValue(); //起始日期
		var endDate = Ext.getCmp("EndDate").getRawValue();     //结束日期
		var UseDays = Ext.getCmp("UseDays").getValue();   //参考天数
        
		if (PurLoc == undefined || PurLoc.length <= 0) {
			Msg.info("warning", $g("请选择采购部门!"));
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
		var stkcat=Ext.getCmp("M_StkCat").getValue();
	 
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
		if (UseDays==""){
	        Msg.info("warning", $g("请填写用药天数!"));
			return;
	    }
		if(ConsumeLoc==""){ConsumeLoc=PurLoc;}  //消耗科室为选择默认采购科室
		var StrParam=ConsumeLoc+"^"+startDate+"^"+endDate+"^"+UseDays+"^"+stkgrp+"^"+TransType+"^"+PurLoc;
		StrParam=StrParam+"^"+session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+stkcat;
		mask.show(); //遮盖
		//生成计划单
		Ext.Ajax.request({
			url: DictUrl+'inpurplanaction.csp?actiontype=CreateInPurPlan',
			params:{strParam:StrParam},
			failure: function(result, request) {
				Msg.info("error",$g("请检查网络连接!"));
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					window.close();
					Msg.info("success","保存成功!");
					mask.hide(); //遮盖隐藏
					purId=jsonData.info;
					Fn(purId);
					//location.href="dhcst.inpurplan.csp?planNnmber="+jsonData.info+'&locId='+locId;
				}else{
					if(jsonData.info==""){
						Msg.info("error",$g("科室或人员为空!"));
					}else if(jsonData.info=="-1"){
						Msg.info("warning",$g("条件范围内无可用数据!"));
					}else{
						Msg.info("error",$g("保存失败!"));
					}
					mask.hide(); //遮盖隐藏
					return;
				}
			},
			scope: this
		});
	  }
			//初始化面板
		var vendorPanel = new Ext.form.FormPanel({
			labelwidth : 30,
			labelAlign : 'right',
			frame : true,
			autoScroll : false,
			//bodyStyle : 'padding:1px;',
			items : [{
				autoHeight : true,
				items : [{
					xtype : 'fieldset',
					title : $g('计划因子'),
					autoHeight : true,
					items : [{
						layout : 'column',
						height:25,
						items : [ 
							{columnWidth:.5,layout:'form',items:[StartDate]},
							{columnWidth:.5,layout:'form',items:[PurLoc]}
						]
				    },{
					    layout : 'column',
					    height:25,
					    items : [
						   {columnWidth:.5,layout:'form',items:[EndDate]},
						   {columnWidth:.5,layout:'form',items:[ConsumeLoc]}
					    ]
				   },{
					    layout : 'column',
					    height:25,
					    items : [
						   {columnWidth:.5,layout:'form',items:[UseDays]},
						   {columnWidth:.5,layout:'form',items:[StkGrpType]}
					    ]
				   },{
					    layout : 'column',
					    height:25,
					    items : [
						   {columnWidth:.5,layout:'form',items:[M_StkCat]}
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
			title:$g('按照科室库存生成采购计划'),
			width:600,
			height:330,
			modal:true,
			resizable:false,
			items:vendorPanel,
			bbar:[sureBT,"-",closeBT]
		})
		
		window.show();
	}