/// 描述：往来处理-往来查询--明细账查询
/// 编写者：初雅莉
/// 编写日期：2015-11-16

Ext.onReady(function(){
	Ext.QuickTips.init();
    //=================================查询条件 FormPanel==========================//
    //会计年度
	var bookID=IsExistAcctBook();
	var userid = session['LOGON.USERID'];

	var acctYearStore = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['AcctYear'])
	});
	acctYearStore.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/herp.acct.currentacctdetailexe.csp?action=GetAcctYear&bookID='+bookID,method:'POST'});
		
	});
	 var acctYear = new Ext.form.ComboBox({
		id : 'acctYear',
		fieldLabel : '会计年度',
		store: acctYearStore,
		emptyText:'请选择会计年度...',
		valueField : 'AcctYear',
		displayField : 'AcctYear',
		width:60,
		listWidth : 60,
		allowBlank: false,
		anchor: '90%',
		//value:'', //默认值
		//valueNotFoundText:'',
		triggerAction: 'all',
		mode: 'local', //本地模式
		editable:false,
		// selectOnFocus: true,
		// forceSelection: 'true',
		//editable:true,
		blankText:'该项为必选项',
		resizable:true,
		listeners : {
		  afterRender : function (com){
			//会计年度，默认为当前年度
			var nowYear = new Date().getFullYear();
			com.setValue(nowYear);
		
	}
	   }
    });
	
	
	//----------------- 往来科目---------------//
	//往来科目store
	var CurSubjStore = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','SubjCode','SubjNameAll','SubjCodeNameAll'])
	});
	CurSubjStore.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/herp.acct.currentacctdetailexe.csp?action=GetCurSubj&str='+Ext.getCmp('acctCurSubj').getRawValue()+"&userid="+userid,method:'POST'});
		ds.baseParams={
			//str:Ext.getCmp('acctCurSubj').getRawValue(),
			start:0,
			userid :userid ,
			str:"",
			limit:10
		};
	});
    //往来科目ComboBox
    var acctCurSubj = new Ext.form.ComboBox({
		id : 'acctCurSubj',
		fieldLabel : '往来科目',
		store: CurSubjStore,
		emptyText:'请选择往来科目...',
		valueField : 'SubjCode',
		displayField : 'SubjCodeNameAll',
		width:200,
		listWidth : 225,
		allowBlank: false,
		anchor: '90%',
		//value:'', //默认值
		//valueNotFoundText:'',
		triggerAction: 'all',
		mode: 'local', //本地模式
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: 'true',
		editable:true,
		resizable:true,
		blankText:'该项为必选项'
    });
	
	//----------------- 往来类型-----------------//
	var CurTypeStore = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['typeID','typeName']),
		remoteSort: false
	});
	acctCurSubj.on("focus",function(){
		connectTip("acctCurSubj");
	});
	//重新选择，清空后面的combox
	acctCurSubj.on("beforeselect",function(){
		var subjId=Ext.getCmp('acctCurSubj').getValue();
      	if(subjId!=""){
			Ext.getCmp('acctCurType').clearValue();
			Ext.getCmp('acctCurObj').clearValue();
	    }
	});
	//往来科目与往来类型联动
    acctCurSubj.on("select",function(cmb,rec,id){
        var str=Ext.getCmp('acctCurType').getValue();
        var subjId=Ext.getCmp('acctCurSubj').getValue();
		CurTypeStore.load({params:{start:0,limit:10,str:str,acctSubj:subjId,userid:userid}});
	});
	
	CurTypeStore.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/herp.acct.currentacctdetailexe.csp?action=GetCurType&str='+Ext.getCmp('acctCurType').getRawValue()+"&userid="+userid,method:'POST'});
		ds.baseParams={
			start:0,
			limit:10,
			str:"",
			acctSubj:Ext.getCmp('acctCurSubj').getValue(),
			userid :userid 
		};
	});
    //往来类型ComboBox
    var acctCurType = new Ext.form.ComboBox({
    	fieldLabel : '往来科目',
		id : 'acctCurType',
    	emptyText:'请选择往来类型...',
    	store: CurTypeStore,
    	valueField : 'typeID',
		displayField : 'typeName',
    	width:150,
		listWidth : 220,
		allowBlank: false,
		anchor: '90%',
		//value:'', //默认值
		//valueNotFoundText:'',
		triggerAction: 'all',
		mode: 'local', //本地模式
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection:'true',
		editable:true,
		resizable:true,//可调整大小
		blankText:'该项为必选项'
    	
    });
	
	acctCurType.on("beforeselect",function(){
		var typeId=Ext.getCmp('acctCurType').getValue();
      	if(typeId!=""){
			Ext.getCmp('acctCurObj').clearValue();
	    }
	});
	//----------------- 往来对象-----------------//
	var CurObjStore = new Ext.data.Store({
		
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','ItemName'])
	//	remoteSort: false,
		
	});
	CurObjStore.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/herp.acct.currentacctdetailexe.csp?action=GetCurObj&str='+Ext.getCmp('acctCurObj').getRawValue()+'&userid='+userid,method:'POST'});
		ds.baseParams={
			start:0,
			limit:10,
			//str:Ext.getCmp('acctCurObj').getRawValue(),
			str:"",
			acctSubj:Ext.getCmp('acctCurSubj').getValue(),
			acctCurType:Ext.getCmp('acctCurType').getValue(),
			userid:userid
		};
	
	});
	acctCurType.on("focus",function(){
		connectTip("acctCurType");
	});
	
    acctCurType.on("select",function(cmb,rec,id){
        var str=Ext.getCmp('acctCurObj').getValue();
        var subjId=Ext.getCmp('acctCurSubj').getValue();
        var acctCurType=Ext.getCmp('acctCurType').getValue();
		CurObjStore.load();
	
	});
	 //往来对象
     var acctCurObj = new Ext.form.ComboBox({
    	fieldLabel : '往来对象',
		id : 'acctCurObj',
    	emptyText:'请选择往来对象...',
    	store:CurObjStore,   
        valueField : 'rowid',
		displayField :'ItemName',
		width:200,
		listWidth : 230,
		allowBlank: false,
		anchor: '90%',
		//value:'', //默认值
		//valueNotFoundText:'',
		triggerAction: 'all',
		mode: 'local', //本地模式
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: 'true',
		editable:true,
		blankText:'该项为必选项',
		resizable:true//可调整大小,
		/*onTriggerClick :function(){
			
			var subjId=Ext.getCmp('acctCurSubj').getValue();
			var acctCurType=Ext.getCmp('acctCurType').getValue();
			CurObjStore.baseParams.str=""
			//console.log(CurObjStore.baseParams.str);
			CurObjStore.load();
		}
		/*,
		listeners:{
			'select':function(){
				//console.log(this);
				CurObjStore.removeListener('beforeload');
				console.log(CurObjStore.hasListener('beforeload'));
			}
		}
		
		*/
    });
	acctCurObj.on("focus",function(){
		connectTip("acctCurObj");
	});
	/*
	acctCurObj.on("valid",function(){
	
		var str=Ext.getCmp('acctCurObj').getRawValue();
        var subjId=Ext.getCmp('acctCurSubj').getValue();
        var acctCurType=Ext.getCmp('acctCurType').getValue();
		//CurObjStore.load({params:{start:0,limit:10,str:str,acctSubj:subjId,acctCurType:acctCurType,userid:userid}});
		
	});
	
	*/
	
    //----------------- 包含未记账-----------------//
    var isAcct = new Ext.form.Checkbox({
    	fieldLabel : '包含未记账',
		id : 'isAcct',
		name : 'isAcct',
		style:'border:0;background:none;margin-top:0px;',
		width:25,
	    labelAlign:'right'
    });
    //----------------- 查询按钮-----------------//
	var buttQuery = new Ext.Button({
    	text:"查询",
		iconCls:'find',
		width:55,
    	handler:function(){ 
			Query();
			}
    
    });
    
	
	
  
    var formPanel2 = new Ext.form.FormPanel({
   		id : 'formPanel2',
		title:'往来明细查询',	
		iconCls:'find',
		frame : true,
		// autoScroll : true,
		items :[{
			columnWidth : 1,
			xtype : 'panel',
			layout : "column",
            items:[{
            	xtype : 'displayfield',
				value : '会计年度',
				style:'padding-top:3px;',
				columnWidth : .14
				//itemCls:"float:right;"
            },acctYear,{
	            xtype : 'displayfield',
	            value : '',
				columnWidth : .05
	        },{
            	xtype : 'displayfield',
				value : ' 往来科目',
				style:'padding-top:3px;',
				columnWidth : .14
            },acctCurSubj,{
	            xtype : 'displayfield',
	            value : '',
				columnWidth : .05
	        },{
           		xtype : 'displayfield',
				value : '往来类型',
				style:'padding-top:3px;',
				columnWidth : .14
            },acctCurType,{
	            xtype : 'displayfield',
	            value : '',
				columnWidth : .05
	        },{
            	xtype : 'displayfield',
				value : '往来对象',
				style:'padding-top:3px;',
				columnWidth : .14
            },acctCurObj,{
	            xtype : 'displayfield',
	            value : '',
				columnWidth : .05
	        },isAcct,{
            	xtype : 'displayfield',
				value : '包含未记账',
				style:'padding-top:3px;',
				columnWidth : .18
            },buttQuery]
		}],
		itemCls:"float:center"
    });
	var reportPanel=new Ext.Panel({
		autoScroll:true,
		layout:'fit',
		//autoScroll:false, 
		html:'<iframe id="frameReport" height="100%" width="100%" frameborder="0" scrolling="auto" src="../scripts/herp/acct/images/logon_bg.jpg" />'
		
	});
    //============================查看=========================================//
    var viewPanel = new Ext.Viewport({
    	layout: 'border',
    	renderTo:'mainPanel',
		items : [{
			region:'north',
			//title:'往来明细查询',						
			height:70,
			//split:true,
			//collapsible:true,
			layout:'fit',
			items:formPanel2
		},{
			region:'center',
			layout:'fit',
			items:reportPanel
		}]
    
    });


	/*
	*往来账查询，明细账界面细节实现
	*
	*/

	//连接报表Query
	function Query(){
		var acctYear=Ext.getCmp('acctYear').getValue();
		var acctCurSubj=Ext.getCmp('acctCurSubj').getValue();
		var acctCurSubj1=Ext.getCmp('acctCurSubj').getRawValue();
		//alert(acctCurSubj1)
		var acctCurType=Ext.getCmp('acctCurType').getValue();
		var acctCurObj=Ext.getCmp('acctCurObj').getValue();
		var acctCurObj1=Ext.getCmp('acctCurObj').getRawValue();
		var isAcct=Ext.getCmp('isAcct').getValue();
		if(isAcct==true){
			isAcct=1;
		}else{
			isAcct=0;
		}
		
		//加入校验
		if(userid==""){
		
			AddAcctBook();
		}else{
			if(acctYear==""){
				Ext.Msg.show({title:'错误',msg:'会计年度不能为空! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				
			}else if(acctCurSubj==""){
				Ext.Msg.show({title:'错误',msg:'往来科目不能为空! ',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else if(acctCurType==""){
				Ext.Msg.show({title:'错误',msg:'往来类型不能为空! ',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else if(acctCurObj==""){
				Ext.Msg.show({title:'错误',msg:'往来对象不能为空! ',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else{
				//===============================显示报表=============================//
				var reportFrame=document.getElementById("frameReport");
				var p_URL="";
				//获取报表路径
				//userid_" "_ acctYear_" "_currentSub_" "_currentObj_" "_currentType_" "_isAcct
				p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.CurrentAcctDetail.raq&userid='+userid+'&acctYear='+acctYear+
							'&currentSub='+acctCurSubj+'&currentSub1='+acctCurSubj1+'&currentObj='+acctCurObj+'&currentObj1='+acctCurObj1+'&currentType='+acctCurType+'&isAcct='+isAcct;
				reportFrame.src=p_URL;
			}
		}	
	}
//连动提示
function connectTip(cmpID){
	var acctYear=Ext.getCmp('acctYear').getValue();
	var acctCurSubj=Ext.getCmp('acctCurSubj').getValue();
	var acctCurType=Ext.getCmp('acctCurType').getValue();
	var acctCurObj=Ext.getCmp('acctCurObj').getValue();

	var msg="";
	if(cmpID=="acctCurSubj"){
		if(acctYear==""){
			msg=msg+'会计年度不能为空! <br/>';
		}
	}else if(cmpID=="acctCurType"){
		if(acctYear==""){
			msg=msg+'会计年度不能为空! <br/>';
		}
		if(acctCurSubj==""){
			msg=msg+'往来科目不能为空! <br/>';
		}
	}else if(cmpID=="acctCurObj"){
		if(acctYear==""){
			msg=msg+'会计年度不能为空! <br/>';
		}
		if(acctCurSubj==""){
			msg=msg+'往来科目不能为空! <br/>';
		}
		if(acctCurType==""){
			msg=msg+'往来类型不能为空! <br/>';
		}
	}
	if(msg!=""){
		Ext.Msg.show({title:'错误',msg:msg,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:'200'});
	}
}
});