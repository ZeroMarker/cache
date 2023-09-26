/**
   *V 1.0
   * 作者：SHP
   * 说明：危急值处理
   * 名称：CriticalValueTrans.js
*/
CVTransMain=function(ReportId,RepType,User){
	this.reportid=ReportId
	this.reptype=RepType
	this.User=User
	this.Status=""
	this.admType=""
	this.saveFlag=0
	//debugger;
	var admTypeOBJ=ExtTool.StaticServerObject("web.DHCCVCommon");
	this.admType=admTypeOBJ.GetPatAdmType(this.reportid,this.reptype)
	this.baseInfo=new BaseInfo(this.reportid,this.reptype)	
	this.RepResult=new Ext.form.TextArea({
		id:'RepResult',
		region:'center',
		cls:'c-textarea',
		//width:775,
		height:200,
		readOnly:true
		//anchor : '99%'
	});
	this.TransInfo=new ContactInfo(this.reportid,this.reptype)
	this.RepResultPanel=new Ext.Panel({
		title:'报告结果',
		iconCls:"c-list-icon",
		height:200,
		border : true,
		layout:'fit',
		id:'RepResultPanel',
		items:[this.RepResult]	
	})
	 this.btnTransFinish = new Ext.Button({
			id : 'TransFinish'
			,text : '保存',
			iconCls:"c-btn-save",
			scope:this,
			handler: function(){
				//this.Status="F"
	  			//this.SaveTrans(this.reportid,this.reptype,this.User,this.Status,this.admType) 
	  			this.saveFlag=1 
	  			this.SaveTrans(this.reportid,this.reptype,this.User,this.admType,this.saveFlag)    
	  		}
		});
	 this.btnTransUnFinish = new Ext.Button({
			id : 'TransUnFinish'
			,text : '通知未完成',
			iconCls:"c-btn-save",
			scope:this,
			handler: function(){
	  		}
		});
	this.btnCancel=new Ext.Button({
			id:'btnCancel',
			text:'取消',
			iconCls:'c-btn-cancel',
			scope:this,
			handler:function(){
				window.close();
				if(top && top.HideExecMsgWin) {top.HideExecMsgWin();}
			}
	});
	this.panel = new Ext.Panel({
			layout:'fit',
			autoScroll:true,
			buttonAlign : 'center',
			frame:true,
			items : [this.baseInfo,this.RepResultPanel,this.TransInfo],
			//items : [this.RepResultPanel],
			//button位置
			buttons:[ this.btnTransFinish,this.btnCancel]
		});
	
	CVTransMain.superclass.constructor.call(this,{
			//title:"危急值报告处理",
			//id:'CVTransMain',
			//region : 'center',
			//height:480,
			//width:800,
			region : 'center',
			closeAction:'close',
			resizable:false,
			closable:true,
			modal:true,
			items:[this.panel]
		})
	this.RepResultDetail()
	//this.SaveTrans(this.reportid,this.reptype,this.User,this.admType,this.saveFlag)
}
Ext.extend(CVTransMain,Ext.Panel,{
	RepResultDetail:function(){
		var RepResult=ExtTool.StaticServerObject("web.DHCCVCommon");
		var Result=RepResult.GetPanicReportResult(this.reptype,this.reportid)
		Ext.getCmp("RepResult").setValue(Result);
	},
	TFSaveData:function(){
	},
	TUFSaveData:function(){
	},
	SaveTrans:function(){
		var TransContact=Ext.getCmp("Contact").getRawValue();
		var TransPhone=Ext.getCmp("ContactTel").getRawValue();
		var TransMemo=Ext.getCmp("ConResult").getRawValue();
		this.Status=Ext.getCmp("ConResult").getValue();
		if(this.admType!="I"){
			if(TransContact==""){
				alert("联系人不能为空！")
				//Ext.getCmp("Contact").setFocus()
				return;
			}
			if(TransPhone==""){
				alert("联系电话不能为空！")
				//Ext.getCmp("Contact").setFocus()
				return;
			}
			/*else if(!isNumber(TransPhone)){
				alert("请填写正确电话号码！")
				return;
			}*/
			
		}
		if ((this.Status=="")&&(this.saveFlag==1)){
			alert("请选择联系结果!")
			return;
			}
		var TransStr="^"+TransContact+"^"+TransPhone+"^"+TransMemo
		var TransOBJ=ExtTool.StaticServerObject("web.DHCAntCVReportTrans")
		var TransResult=TransOBJ.SaveTransNew(ReportId,User,TransStr,this.Status,RepType)
		if(this.saveFlag==1){
				if(TransResult==0){
				    alert("保存成功!")
				    window.close()
				    if(top && top.HideExecMsgWin) {top.HideExecMsgWin();}
				}else{
					alert("数据插入失败！")
					}
		}else{
			if(TransResult!=0){
				    alert("日志记录保存失败!")
				    window.close()
				    if(top && top.HideExecMsgWin) {top.HideExecMsgWin();}
				}
			}
		
	}
})
BaseInfo=function(ReportId,RepType){
	this.reportid=ReportId;
	this.reptype=RepType;
	this.IDTab=new Ext.form.Label( {
        id:"IDField", 
        text:"登记号", 
        cls:'x-form-item'
	})
	this.IDVal=new Ext.form.Label( {
        id:"IDValField",
        cls:'c-label'
	})
	this.PatNameLab=new Ext.form.Label( {
        id:"PatNameLabField", 
        text:"姓名",
        cls:'x-form-item'
	})
	this.PatNameVal=new Ext.form.Label( {
        id:"PatNameValField",
        cls:'c-label'
	})
	
	this.SexTab=new Ext.form.Label( {
        id:"SexField", 
        text:"性别",
        cls:'x-form-item'
	})
	this.SexVal=new Ext.form.Label( {
        id:"SexValField",
        cls:'c-label'
	})
	
	this.AgeTab=new Ext.form.Label( {
        id:"AgeField", 
        text:"年龄",
        cls:'x-form-item'
	})
	this.AgeVal=new Ext.form.Label( {
        id:"AgeValField",
        cls:'c-label'
	})

	this.MedCareTab=new Ext.form.Label( {
        id:"MedCareField", 
        text:"病案号",
        cls:'x-form-item'
	})
	this.MedCareVal=new Ext.form.Label( {
        id:"MedCareValField",
        cls:'c-label'
	})
	var NoTabName=tkMakeServerCall("web.DHCAntCVReportNameQuery","GetPanicName",this.reptype);
	this.BBNoTab=new Ext.form.Label( {
        id:"BBNoField", 
        text:NoTabName+"号",
        cls:'x-form-item' 
	})
	this.BBNoVal=new Ext.form.Label( {
        id:"BBNoValField",
        cls:'c-label'
	})
	
	this.AppDepTab=new Ext.form.Label( {
        id:"AppDepField", 
        text:"申请科室",
        cls:'x-form-item' 
	})
	this.AppDepVal=new Ext.form.Label( {
        id:"AppDepValField",
        cls:'c-label'
	})
	
	this.AppDocTab=new Ext.form.Label( {
        id:"AppDocField", 
        text:"申请医生",
        cls:'x-form-item' 
	})
	this.AppDocVal=new Ext.form.Label( {
        id:"AppDocValField",
        cls:'c-label'
	})
	
	this.TelTab=new Ext.form.Label( {
        id:"TelField", 
        text:"联系电话",
        cls:'x-form-item'
	})
	this.TelVal=new Ext.form.Label( {
        id:"TelValField",
        cls:'c-label'
	})
	
	this.ArcItemTab=new Ext.form.Label( {
        id:"ArcItemField", 
        text:"项目",
        cls:'x-form-item'
	})
	this.ArcItemVal=new Ext.form.Label( {
        id:"ArcItemValField",
        cls:'c-long-label'
	})
	this.ArcItemCondition=new Ext.form.FormPanel({
			id:'Condition',
			//layout:'form',
			//width:480,
        	layout:'column',
        	items:[{
	        		layout:'form',
	        		columnWidth:.08,
        			labelAlign : 'right',
					bodyStyle : "padding:10px 0px 0px 10px",
	        		region:'right',
					items:[this.TelTab ]
				},{
	        		layout:'form',
	        		columnWidth:.12,
	        		labelAlign : 'right',
					bodyStyle : "padding:10px 5px",
					items:[
						this.TelVal ]
				},{
					layout:'form',
					columnWidth:.08,
        			labelAlign : 'right',
					bodyStyle : "padding:10px 0px 0px 10px",
					items:[this.ArcItemTab]
				},{
					layout:'form',
					columnWidth:.32,
					labelAlign : 'right',
					bodyStyle : "padding:10px 5px",
					items:[this.ArcItemVal]
        	}]
		})
	this.ArcItemCondition2=new Ext.form.FormPanel({
			id:'Condition2',
        	layout:'column',
        	items:[{		
					layout:'form',
					columnWidth:.08,
					labelAlign : 'right',
					bodyStyle : "padding:10px 0px 0px 10px",
					region:'right',
					items:[this.BBNoTab]
				},{
	        		layout:'form',
	        		columnWidth:.12,
	        		labelAlign : 'right',
					bodyStyle : "padding:10px 5px",
					items:[this.BBNoVal]
				},{
	        		layout:'form',
	        		columnWidth:.08,
        			labelAlign : 'right',
					bodyStyle : "padding:10px 0px 0px 0px",
	        		region:'right',
					items:[this.MedCareTab]
				},{
	        		layout:'form',
	        		columnWidth:.12,
	        		labelAlign : 'right',
					bodyStyle : "padding:10px 5px;",
					items:[
						this.MedCareVal]
				},{
	        		layout:'form',
	        		columnWidth:.08,
        			labelAlign : 'right',
					bodyStyle : "padding:10px 0px 0px 0px",
	        		region:'right',
					items:[this.AppDepTab ]
				},{
	        		layout:'form',
	        		columnWidth:.12,
	        		labelAlign : 'right',
					bodyStyle : "padding:10px 5px",
					items:[this.AppDepVal]
				},{
	        		layout:'form',
	        		columnWidth:.08,
        			labelAlign : 'right',
					bodyStyle : "padding:10px 0px 0px 0px",
	        		region:'right',
					items:[this.AppDocTab ]
				},{
	        		layout:'form',
	        		columnWidth:.12,
	        		labelAlign : 'right',
					bodyStyle : "padding:10px 5px",
					items:[this.AppDocVal ]
				}]
		})
	BaseInfo.superclass.constructor.call(this,{
		title: '基本信息',
        collapsible: true,
		iconCls:"c-useaim-icon",
        autoHeight:346,
        //bodyBorder : 'padding:1 1 1 1',
        //defaultType: 'label',
        items :[{
        	layout:'column',
        	items:[{		
					layout:'form',
					columnWidth:.08,
					labelAlign : 'left',
					bodyStyle : "padding:10px 0px 0px 0px", 
					region:'right',
					items:[this.IDTab]
				},{
	        		layout:'form',
	        		columnWidth:.12,
	        		labelAlign : 'left',
					bodyStyle : "padding:10px 5px", 
					items:[this.IDVal]
				},{
	        		layout:'form',
	        		columnWidth:.08,
        			labelAlign : 'left',
					bodyStyle : "padding:10px 0px 0px 10px",
	        		region:'right',
					items:[this.PatNameLab]
				},{
	        		layout:'form',
	        		columnWidth:.12,
	        		labelAlign : 'left',
					bodyStyle : "padding:10px 5px",
					items:[this.PatNameVal]
				},{
	        		layout:'form',
	        		columnWidth:.08,
        			labelAlign : 'left',
					bodyStyle : "padding:10px 0px 0px 10px",
	        		region:'right',
					items:[this.SexTab]
				},{
	        		layout:'form',
	        		columnWidth:.12,
	        		labelAlign : 'left',
					bodyStyle : "padding:10px 5px",
					items:[this.SexVal]
				},{
	        		layout:'form',
	        		columnWidth:.08,
        			labelAlign : 'left',
					bodyStyle : "padding:10px 0px 0px 10px",
	        		region:'right',
					items:[this.AgeTab]
				},{
	        		layout:'form',
	        		columnWidth:.12,
	        		labelAlign : 'left',
					bodyStyle : "padding:10px 5px",
					items:[this.AgeVal]
				}]
        	},
			this.ArcItemCondition2,
        	this.ArcItemCondition
        	]
        });
      this.SetBaseInfo()
}
/*

	

*/
Ext.extend(BaseInfo,Ext.Panel,{
	SetBaseInfo:function(){
		var epis=this.reportid.split("||")[0]
		var BaseInfoOBJ=ExtTool.StaticServerObject("web.DHCAntCVReportSearch");
		var Result=BaseInfoOBJ.GetPanicReportInfo(epis,this.reptype)
		var retArr=Result.split("\\");
		//alert(retArr)
		Ext.getCmp("IDValField").setText(retArr[0]);
		Ext.getCmp("PatNameValField").setText(retArr[1]);
		Ext.getCmp("SexValField").setText(retArr[2]);
		Ext.getCmp("AgeValField").setText(retArr[3]);
		Ext.getCmp("MedCareValField").setText(retArr[4]);
		//Ext.getCmp("BBNoValField").setText(retArr[1]);
		Ext.getCmp("BBNoValField").setText(epis);
		Ext.getCmp("AppDepValField").setText(retArr[7]);
		Ext.getCmp("AppDocValField").setText(retArr[8]);
		Ext.getCmp("TelValField").setText(retArr[13]);
		Ext.getCmp("ArcItemValField").setText(retArr[5]);
	}
})
ContactInfo=function(ReportId,RepType){
	this.reportid=ReportId;
	this.reptype=RepType;
	this.Contact=new Ext.form.TextField({
				id:'Contact',
				fieldLabel:'联系人',
				width:200
				//,anchor : '100%'
	});
	this.ContactTel=new Ext.form.TextField({
				id:'ContactTel',
				fieldLabel:'联系电话',
				width:200
				//anchor : '80%'
	});
	/*this.ConResult=new Ext.form.TextField({
				id:'ConResult',
				fieldLabel:'联系结果',
				hight:200,
				anchor : '90%'
	});*/
	var Data=[['C','未通知'],['F','已通知']]
	var ComboStore=new Ext.data.SimpleStore({
			fields:['id','desc'],
			data:Data
	});
	this.ConResult=new Ext.form.ComboBox({
			id:'ConResult',
			store: ComboStore,
			displayField:'desc',
			valueField : 'id',
			//editable:false,
			fieldLabel : "联系结果",
			width:200,
			mode : 'local',
			anchor : '90%'
			,triggerAction : 'all'
	})
	
	ContactInfo.superclass.constructor.call(this,{
			id:'ContactInfo',
			title: '处理信息',
			border:true,
			iconCls:"c-apply-icon",
        	autoHeight:250,
			layout:'fit',
        	layout:'column',
        	//labelAlign:"right",
        	items:[
	        				{
								columnWidth:.5,
								//labelAlign:"right",
								items:[
										{
												layout:'form',
												labelSeparator:'&nbsp',
												labelAlign:"right",
												items:[
														this.Contact,
														this.ContactTel
												]
										}
								]
							},{
										columnWidth:.5,
										layout:'form',
										labelSeparator:'&nbsp',
										labelAlign:"right",
										columnHight:200,
										items:[
												this.ConResult
										]
								}
        		]
	})
	this.SetContactInfo();
}
Ext.extend(ContactInfo,Ext.Panel,{
	SetContactInfo:function(){
		//var epis=this.reportid.split("||")[0]
		var InfoOBJ=ExtTool.StaticServerObject("web.DHCCVCommon");
		var Result=InfoOBJ.GetCantactInfo(this.reportid,this.reptype)
		var retArr=Result.split("\\");
		Ext.getCmp("Contact").setValue(retArr[0]);
		Ext.getCmp("ContactTel").setValue(retArr[1]);
		if(retArr[2]=="已通知"){
			Ext.getCmp("ConResult").setValue("F");
			Ext.getCmp("ConResult").setRawValue(retArr[2]);
		}else if(retArr[2]=="未通知"){
			Ext.getCmp("ConResult").setValue("C");
			Ext.getCmp("ConResult").setRawValue(retArr[2]);
		}
		
	}
})
//Ext.reg('ContactInfo',ContactInfo)
//Ext.extend(ContactInfo,Ext.form.FormPanel,{})