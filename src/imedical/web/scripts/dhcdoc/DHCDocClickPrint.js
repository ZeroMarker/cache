
//功能：一键打印页面窗口
//创建时间：2014-08-01

//卡消费调用计费接口,此处待做配置，当ConsumeFlag=true是进行卡消费操作，暂时写死
var ConsumeFlag=false;
var ExtToolSetting = new Object();
ExtToolSetting.RunQueryPageURL = "./dhc.med.query.csp"
PrtClickInfo=function(EpisodeID,PatientID,MRADMID,ctlocid,userid) {
	var obj = new Object();
	//this.userid=userid;
//alert("LL++"+EpisodeID)
//alert(userid)
	obj.gridResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridResultStore = new Ext.data.Store({
		id: 'gridResultStore',
		proxy: obj.gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total'
			,idProperty: 'OrderItemRowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'OrderItemRowid', mapping : 'OEItemID'}
			,{name: 'OEORIOEORIDR', mapping : 'OEItemDR'}
			,{name: 'ARCIMRowId', mapping : 'ARCIMRowId'}
			,{name: 'OrderDocRowid', mapping: 'UserAddID'}
			,{name: 'OrderRecDepRowid', mapping: 'ReLocID'}
			,{name: 'PHFreqDesc', mapping: 'PHFreqDesc'}
			,{name: 'printFlag', mapping: 'OrderPrintFlag'}
			,{name: 'OrderName', mapping: 'ArcimDesc'}
			,{name: 'OrderDoseQty', mapping: 'DoseQty'}
			,{name: 'OrderDoseUOM', mapping: 'DoseUnit'}
			,{name: 'OrderFreq', mapping: 'PHFreq'}
			,{name: 'OrderInstr', mapping: 'Instr'}
			,{name: 'OrderDur', mapping: 'Dura'}
			,{name: 'OrderPrescNo', mapping: 'OrderPrescNo'}
			,{name: 'OrderPrice', mapping: 'ArcPrice'}
			,{name: 'OrderPackQty', mapping: 'OrderPackQty'}
			,{name: 'OrderPackUOM', mapping: 'PackUOMDesc'}
			,{name: 'OrderRecDep', mapping: 'ReLoc'}
			,{name: 'UserAdd', mapping: 'UserAdd'}
			,{name: 'OrderSum', mapping: 'OrderSum'}
			,{name: 'OrdBilled', mapping: 'OrdBilled'}
			,{name: 'OrdStatus', mapping: 'OrdStatus'}
			,{name: 'OrderType', mapping: 'OrderType'}
			,{name: 'OrdDepProcNotes', mapping: 'OrdDepProcNotes'}
		])
	});

	obj.gridRowSelectionModel = new Ext.grid.RowSelectionModel({})
	obj.gridCheckboxSelectionModel = new Ext.grid.CheckboxSelectionModel({handleMouseDown : Ext.emptyFn, dataIndex: 'checked' ,align:'right'}); //复选框模型
	obj.gridResult = new Ext.grid.GridPanel({
		id : 'gridResult'
		,store : obj.gridResultStore
		,sm : obj.gridCheckboxSelectionModel //复选框选择模型
		//,sm : obj.gridRowSelectionModel
		,height: 300
		,width:900
		,region : 'center'
		,buttonAlign : 'center'
		,autoScroll : true
		,bodyStyle :'overflow-x:visible;overflow-y:scroll' //隐藏水平滚动条,显示用overflow-x:visible
		,loadMask : { msg : '正在读取数据,请稍后...'} 
		,columns: [
			new Ext.grid.RowNumberer({header:" ",width:15,align:'center',hidden:true})
			,obj.gridCheckboxSelectionModel
			,{header: 'ARCIMRowId', width: 100, dataIndex: 'ARCIMRowId',hidden:true}
			,{header: 'OrderDocRowid', width: 100, dataIndex: 'OrderDocRowid',hidden:true}
			,{header: 'OrderItemRowid', width: 60, dataIndex: 'OrderItemRowid',hidden:true}
			,{header: 'OEORIOEORIDR', width: 60, dataIndex: 'OEORIOEORIDR', hidden:true}	
			,{header: 'OrderRecDepRowid', width: 100, dataIndex: 'OrderRecDepRowid', hidden:true}
			,{header: 'PHFreqDesc', width: 100, dataIndex: 'PHFreqDesc', hidden:true}
			,{header: '打印',width: 33 , dataIndex: 'printFlag', align : 'center' }
			,{header: '医嘱名称', width: 150, dataIndex: 'OrderName', align : 'left'}
			,{header: '计费状态', width: 60, dataIndex: 'OrdBilled', align : 'center',renderer:function(v,m){ if(v=="已收费")m.css='x-grid-back-red';return v; }}
			,{header: '医嘱状态', width: 60, dataIndex: 'OrdStatus', align : 'center'}
			,{header: '单次剂量', width: 60, dataIndex: 'OrderDoseQty', align : 'center'}
			,{header: '单位', width: 40, dataIndex: 'OrderDoseUOM', align : 'center'}
			,{header: '频次', width: 40, dataIndex: 'OrderFreq', align : 'center'}
			,{header: '用法', width: 50, dataIndex: 'OrderInstr', align : 'center'}
			,{header: '疗程', width: 40, dataIndex: 'OrderDur', align : 'center'}
			,{header: '处方号', width: 100, dataIndex: 'OrderPrescNo', align : 'center',sortable: true}
			,{header: '单价/元', width: 60, dataIndex: 'OrderPrice', align : 'center'}
			,{header: '数量', width: 50, dataIndex: 'OrderPackQty', align : 'center'}
			,{header: '单位', width: 50, dataIndex: 'OrderPackUOM', align : 'center'}
			,{header: '接收科室', width: 100, dataIndex: 'OrderRecDep', align : 'center'}
			,{header: '开医嘱人', width: 60, dataIndex: 'UserAdd', align : 'center', hidden:true}
			,{header: '金额', width: 50, dataIndex: 'OrderSum', align : 'center'}
			,{header: '医嘱类型', width: 60, dataIndex: 'OrderType',align : 'center',hidden:true}
			,{header: '备注', width: 60, dataIndex: 'OrdDepProcNotes',align : 'center'}
		]
		/*,viewConfig:{
			getRowClass:function(record,rowIndex,p,ds){
				 var cls = '';
				 if (record.data.OrdBilled== "已收费"){
					 cls = 'x-grid-record-red';
				 }
				 else if(record.data.OrdBilled== ""){
					 cls = '';    
				 }
				 return cls;
			}  
		}*/
	});
	
	
	//obj.gridResult.store.sort('OrderType','DESC');//或者ASC
	
	obj.gridResultStoreProxy.on('beforeload',function(objProxy,param){
				param.ClassName = 'web.DHCDocQryOEOrder';
				param.QueryName = 'GetOrdByAdm';		
				param.Arg1 = EpisodeID ;
				param.Arg2 = userid;
				param.ArgCnt=2;
				//Ext.Msg(param.Arg1.value)
		});
	
	obj.TotalExpenses = new Ext.form.TextField({
		id : 'TotalExpenses' 
		,width : 100
		,anchor : '80%'
		,disabled : true
		,fieldLabel : '费用合计' 
	});
	obj.pConditionChild1=new Ext.Panel({
		id : 'pConditionChild1'
		,buttonAlign:'center'
		,fieldAlign : 'right'
		,columnWidth : .3
		,labelWidth:70
		,layout:'form'
		,items:[obj.TotalExpenses]
	});
	
	obj.ThisDepartment = new Ext.form.TextField({
		id : 'ThisDepartment'
		,width : 100
		,anchor : '80%'
		,disabled : true
		,fieldLabel : '本科费用'
	});
	obj.pConditionChild2=new Ext.Panel({
		id : 'pConditionChild2'
		,buttonAlign:'center'
		,fieldAlign : 'right'
		,columnWidth : .3
		,labelWidth:70
		,layout:'form'
		,items:[obj.ThisDepartment]
	});
	
	obj.CardBalance = new Ext.form.TextField({
		id : 'CardBalance'
		,width : 100
		,anchor : '80%'
		,disabled : true
		,fieldLabel : '卡内余额'
	});
	obj.pConditionChild3=new Ext.Panel({
		id : 'pConditionChild3'
		,buttonAlign:'center'
		,fieldAlign : 'right'
		,columnWidth : .3
		,labelWidth:70
		,layout:'form'
		,items:[obj.CardBalance]
	});
	/*obj.CardBalance.on('disable',function(param){
				param.ClassName = 'web.DHCDocStatisticsQry';
				param.QueryName = 'QryStatistics';		
				param.Arg1 = EpisodeID ;
				param.ArgCnt=1;
		});*/
	
	obj.tFieldset = new Ext.form.FieldSet({
		id : 'tFieldset'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,height:40
		,layout : 'column'
		,border:true
		,frame:true
		,anchor:'100%'
		,items : [
			obj.pConditionChild1
			,obj.pConditionChild2
			,obj.pConditionChild3
		]
	});
	
	obj.myCheckboxGroup = new Ext.form.CheckboxGroup({  
		id:'myCheckboxGroup',
		buttonAlign : 'center',
		columns: [.15,.25,.25,.15,.2],
		labelAlign : 'center',
		xtype: 'checkboxgroup',
		columnWidth : 1,
		items: [  
			//{boxLabel: '卡消费', columnWidth:.25,id: 'consume',checked: true}
			//,{boxLabel: '处方', columnWidth:.25,id: 'recipe',checked: true} 
			//,{boxLabel: '导诊单', columnWidth:.25,id: 'guide'}
			//,{boxLabel: '医嘱单', columnWidth:.25,id: 'order',checked: true}
			//,{boxLabel: '申请单',columnWidth:.2, id: 'apply',checked: true}
			{boxLabel: '卡消费',id: 'consume',checked: true}
			,{boxLabel: '处方[正]',id: 'frontFlag',checked: true} 
			,{boxLabel: '处方[底]',id: 'backFlag',checked: true} 
			,{boxLabel: '导诊单',id: 'guide'}
			,{boxLabel: '医嘱单',id: 'order',checked: true}  
		
		]  
	});
	if (ConsumeFlag==true) {
		var AdmSource=tkMakeServerCall("web.DHCBillInterface","GetAdmSourceByAdm",EpisodeID);
		if(AdmSource!=0){
			//alert(AdmSource)
			obj.myCheckboxGroup.items[0].checked=false;
			obj.myCheckboxGroup.items[0].disabled=true;
		}else{
			obj.myCheckboxGroup.items[0].checked=true;
			obj.myCheckboxGroup.items[0].disabled=true;	
		}
	}else{
		obj.myCheckboxGroup.items[0].checked=false;
		obj.myCheckboxGroup.items[0].disabled=true;
	}
	//得到计费组的配置,判断是否需要在医生站打印导诊单
	//"F"：收费打印；"D"：医生站打印，空，都不打印
	var IsNeedPrintGuide=tkMakeServerCall("web.DHCBillInterface","GetPrtGuideFlag");
	if (IsNeedPrintGuide=="D") {
		obj.myCheckboxGroup.items[3].checked=true;
		obj.myCheckboxGroup.items[3].disabled=false;
	}else{
		obj.myCheckboxGroup.items[3].checked=false;
		obj.myCheckboxGroup.items[3].disabled=true;
	}
	
	obj.bFieldset = new Ext.form.FieldSet({
		id : 'bFieldset'
		,buttonAlign : 'center'
		,labelAlign : 'center'
		,height:40
		,layout : 'column'
		,border:true
		,frame:true
		,anchor:'100%'
		,items : [
			obj.myCheckboxGroup
		]
	});
	
	obj.printButton = new Ext.Button({
		id : 'printButton'
		,width : 100
		,iconCls : 'icon-export'
		,text : '打印'
	});
	obj.btnCancel=new Ext.Button({
		id:'btnCancel',
		width : 100,
		text:'关闭',
		iconCls:'icon-exit',
		scope:this,
		handler:function(){ 
			obj.winPrtClickInfo.close();
			
		}
	});
	obj.btnCancleOrder = new Ext.Button({
		id : 'btnCancleOrder'
		,width : 100
		,iconCls : 'icon-exit'
		,text : '取消医嘱'
	});
	
	obj.buttonPanel = new Ext.Panel({
		id:'buttonPanel'
		,buttonAlign:'center'
		,layout:'column'
		//,anchor:'100%'
		,width:300
		,height:155
		,items : [
			obj.printButton,
			obj.btnCancel,
			obj.btnCancleOrder
		]
	});
	
	obj.htmlDiv = new Ext.Panel({
		id:'htmlDiv'
		,buttonAlign:'left'
		//,anchor:'100%'
		,width:300
		,height:30
		,html:'<div id ="htmlDiv1" style="color:red;font-size:15px;font-weight:bold"></div>,<div id ="htmlDiv2" style="color:#00FF00;font-size:18px;font-weight:bold"></div>'	
	});

	
	
	obj.btnFieldset = new Ext.form.FieldSet({
		id : 'btnFieldset'
		,buttonAlign : 'center'
		//,fieldAlign:'right'
		,height:185
		,layout : 'column'
		,anchor:'100%'
		,items : [
			obj.htmlDiv,
			obj.buttonPanel
		]
	});
	//Ext.getCmp('htmlDiv').html="LLL";

	obj.centerPanel = new Ext.Panel({
		id : 'centerPanel'
		,height : 200
		,buttonAlign : 'center'
		,region : 'center'
		,frame : true
		,layout : 'form'
		,items:[
			obj.tFieldset,
			obj.bFieldset,
			obj.btnFieldset
		]
	});
	
	
	obj.pnScreen = new Ext.Panel({
		id : 'pnScreen'
		,buttonAlign : 'center'
		,frame : true
		,layout : 'border'
		,items:[
			{region:"north",height:300,border:true,items:[obj.gridResult]},
			{region:"center",height:250,border:true,items:[obj.centerPanel]}
		]
	});

	obj.winPrtClickInfo = new Ext.Window({
		id : 'winPrtClickInfo',
		x : 50,
		y : 0,
		height:550,
		width:950,
		title:'一键打印',
		layout:'fit',
		closeAction:'close',
		resizable:false,
		closable:true,
		modal:true,
		items:[
			obj.pnScreen		
		]
	});

	obj.gridResultStore.on('load',function(){
		var TypeFlag=0;
		
		//如果是不启用卡消费,则下面的信息不提示
		var consumeobj=Ext.getCmp("consume");
		if(consumeobj.checked){
			if(AdmSource!=0){
				document.getElementById('htmlDiv1').innerHTML="医保病人请到收费处交费。";	
			}
			if(AdmSource==0){
				var TotalExpenses = Ext.getCmp('TotalExpenses').getValue();//.html='请修改为你要的值';
				var CardBalance = Ext.getCmp('CardBalance').getValue();
				//alert(TotalExpenses+"++++"+CardBalance);
				if(parseFloat(TotalExpenses)>=parseFloat(CardBalance)){
					
					document.getElementById('htmlDiv1').innerHTML="卡内余额不足，提示患者到收费处交费。"
				}else{
					document.getElementById('htmlDiv2').innerHTML="卡内余额充足，药品可消费。"	
				}
			}
		}
		var records=[];//存放选中记录  
		for(var i=0;i<obj.gridResultStore.getCount();i++){ 	
			var record = obj.gridResultStore.getAt(i);
			var OrderItemRowid = record.get("OrderItemRowid"); 
    		var OEORIOEORIDR = record.get("OEORIOEORIDR"); 
    		var OrderType = record.get("OrderType"); 
    		if(OrderType=="R"){
	    		var OrderTypeFlag=0
    		}else{
	    		var OrderTypeFlag=1
	    	}
    		if(record.get("printFlag")!="Y"){//根据后台数据判断那些记录默认选中  
     			records.push(record);  
    			}
    		if (OEORIOEORIDR==""){
    			for(var j=0;j<obj.gridResultStore.getCount();j++){ 	
    				var record1 = obj.gridResultStore.getAt(j);
    				var OrderItemRowid1 = record1.get("OrderItemRowid"); 
    				var OEORIOEORIDR1 = record1.get("OEORIOEORIDR");	 	
    				if (OEORIOEORIDR1==OrderItemRowid){
	    				obj.gridResult.getView().getRow(i).style.backgroundColor="#60f807" ;//'#00ccff';
    				}
    			}   
    		}  
    	obj.gridCheckboxSelectionModel.selectRecords(records);//执行选中记录  
    	var TypeFlag=TypeFlag+OrderTypeFlag;
    	}
    	var guideobj=Ext.getCmp("guide");
		if (guideobj.disabled==false) {
			if (TypeFlag>0){
				guideobj.setValue(true);
			}else{
				guideobj.setValue(false);
			}
		}			
    	
	});
	
	obj.winPrtClickInfo.show();
	obj.winPrtClickInfo.on("close",function(){
		//window.parent.location.reload(); 
		UpdateClickHandlerFinish();	
	})
	PrtClickInfoEvent(obj,EpisodeID,PatientID,MRADMID,ctlocid);
	obj.LoadEvent(arguments);
	return obj;
}