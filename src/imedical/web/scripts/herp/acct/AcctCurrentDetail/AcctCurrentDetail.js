/// ��������������-������ѯ--��ϸ�˲�ѯ
/// ��д�ߣ�������
/// ��д���ڣ�2015-11-16

Ext.onReady(function(){
	Ext.QuickTips.init();
    //=================================��ѯ���� FormPanel==========================//
    //������
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
		fieldLabel : '������',
		store: acctYearStore,
		emptyText:'��ѡ�������...',
		valueField : 'AcctYear',
		displayField : 'AcctYear',
		width:60,
		listWidth : 60,
		allowBlank: false,
		anchor: '90%',
		//value:'', //Ĭ��ֵ
		//valueNotFoundText:'',
		triggerAction: 'all',
		mode: 'local', //����ģʽ
		editable:false,
		// selectOnFocus: true,
		// forceSelection: 'true',
		//editable:true,
		blankText:'����Ϊ��ѡ��',
		resizable:true,
		listeners : {
		  afterRender : function (com){
			//�����ȣ�Ĭ��Ϊ��ǰ���
			var nowYear = new Date().getFullYear();
			com.setValue(nowYear);
		
	}
	   }
    });
	
	
	//----------------- ������Ŀ---------------//
	//������Ŀstore
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
    //������ĿComboBox
    var acctCurSubj = new Ext.form.ComboBox({
		id : 'acctCurSubj',
		fieldLabel : '������Ŀ',
		store: CurSubjStore,
		emptyText:'��ѡ��������Ŀ...',
		valueField : 'SubjCode',
		displayField : 'SubjCodeNameAll',
		width:200,
		listWidth : 225,
		allowBlank: false,
		anchor: '90%',
		//value:'', //Ĭ��ֵ
		//valueNotFoundText:'',
		triggerAction: 'all',
		mode: 'local', //����ģʽ
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: 'true',
		editable:true,
		resizable:true,
		blankText:'����Ϊ��ѡ��'
    });
	
	//----------------- ��������-----------------//
	var CurTypeStore = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['typeID','typeName']),
		remoteSort: false
	});
	acctCurSubj.on("focus",function(){
		connectTip("acctCurSubj");
	});
	//����ѡ����պ����combox
	acctCurSubj.on("beforeselect",function(){
		var subjId=Ext.getCmp('acctCurSubj').getValue();
      	if(subjId!=""){
			Ext.getCmp('acctCurType').clearValue();
			Ext.getCmp('acctCurObj').clearValue();
	    }
	});
	//������Ŀ��������������
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
    //��������ComboBox
    var acctCurType = new Ext.form.ComboBox({
    	fieldLabel : '������Ŀ',
		id : 'acctCurType',
    	emptyText:'��ѡ����������...',
    	store: CurTypeStore,
    	valueField : 'typeID',
		displayField : 'typeName',
    	width:150,
		listWidth : 220,
		allowBlank: false,
		anchor: '90%',
		//value:'', //Ĭ��ֵ
		//valueNotFoundText:'',
		triggerAction: 'all',
		mode: 'local', //����ģʽ
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection:'true',
		editable:true,
		resizable:true,//�ɵ�����С
		blankText:'����Ϊ��ѡ��'
    	
    });
	
	acctCurType.on("beforeselect",function(){
		var typeId=Ext.getCmp('acctCurType').getValue();
      	if(typeId!=""){
			Ext.getCmp('acctCurObj').clearValue();
	    }
	});
	//----------------- ��������-----------------//
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
	 //��������
     var acctCurObj = new Ext.form.ComboBox({
    	fieldLabel : '��������',
		id : 'acctCurObj',
    	emptyText:'��ѡ����������...',
    	store:CurObjStore,   
        valueField : 'rowid',
		displayField :'ItemName',
		width:200,
		listWidth : 230,
		allowBlank: false,
		anchor: '90%',
		//value:'', //Ĭ��ֵ
		//valueNotFoundText:'',
		triggerAction: 'all',
		mode: 'local', //����ģʽ
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: 'true',
		editable:true,
		blankText:'����Ϊ��ѡ��',
		resizable:true//�ɵ�����С,
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
	
    //----------------- ����δ����-----------------//
    var isAcct = new Ext.form.Checkbox({
    	fieldLabel : '����δ����',
		id : 'isAcct',
		name : 'isAcct',
		style:'border:0;background:none;margin-top:0px;',
		width:25,
	    labelAlign:'right'
    });
    //----------------- ��ѯ��ť-----------------//
	var buttQuery = new Ext.Button({
    	text:"��ѯ",
		iconCls:'find',
		width:55,
    	handler:function(){ 
			Query();
			}
    
    });
    
	
	
  
    var formPanel2 = new Ext.form.FormPanel({
   		id : 'formPanel2',
		title:'������ϸ��ѯ',	
		iconCls:'find',
		frame : true,
		// autoScroll : true,
		items :[{
			columnWidth : 1,
			xtype : 'panel',
			layout : "column",
            items:[{
            	xtype : 'displayfield',
				value : '������',
				style:'padding-top:3px;',
				columnWidth : .14
				//itemCls:"float:right;"
            },acctYear,{
	            xtype : 'displayfield',
	            value : '',
				columnWidth : .05
	        },{
            	xtype : 'displayfield',
				value : ' ������Ŀ',
				style:'padding-top:3px;',
				columnWidth : .14
            },acctCurSubj,{
	            xtype : 'displayfield',
	            value : '',
				columnWidth : .05
	        },{
           		xtype : 'displayfield',
				value : '��������',
				style:'padding-top:3px;',
				columnWidth : .14
            },acctCurType,{
	            xtype : 'displayfield',
	            value : '',
				columnWidth : .05
	        },{
            	xtype : 'displayfield',
				value : '��������',
				style:'padding-top:3px;',
				columnWidth : .14
            },acctCurObj,{
	            xtype : 'displayfield',
	            value : '',
				columnWidth : .05
	        },isAcct,{
            	xtype : 'displayfield',
				value : '����δ����',
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
    //============================�鿴=========================================//
    var viewPanel = new Ext.Viewport({
    	layout: 'border',
    	renderTo:'mainPanel',
		items : [{
			region:'north',
			//title:'������ϸ��ѯ',						
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
	*�����˲�ѯ����ϸ�˽���ϸ��ʵ��
	*
	*/

	//���ӱ���Query
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
		
		//����У��
		if(userid==""){
		
			AddAcctBook();
		}else{
			if(acctYear==""){
				Ext.Msg.show({title:'����',msg:'�����Ȳ���Ϊ��! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				
			}else if(acctCurSubj==""){
				Ext.Msg.show({title:'����',msg:'������Ŀ����Ϊ��! ',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else if(acctCurType==""){
				Ext.Msg.show({title:'����',msg:'�������Ͳ���Ϊ��! ',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else if(acctCurObj==""){
				Ext.Msg.show({title:'����',msg:'����������Ϊ��! ',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else{
				//===============================��ʾ����=============================//
				var reportFrame=document.getElementById("frameReport");
				var p_URL="";
				//��ȡ����·��
				//userid_" "_ acctYear_" "_currentSub_" "_currentObj_" "_currentType_" "_isAcct
				p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.CurrentAcctDetail.raq&userid='+userid+'&acctYear='+acctYear+
							'&currentSub='+acctCurSubj+'&currentSub1='+acctCurSubj1+'&currentObj='+acctCurObj+'&currentObj1='+acctCurObj1+'&currentType='+acctCurType+'&isAcct='+isAcct;
				reportFrame.src=p_URL;
			}
		}	
	}
//������ʾ
function connectTip(cmpID){
	var acctYear=Ext.getCmp('acctYear').getValue();
	var acctCurSubj=Ext.getCmp('acctCurSubj').getValue();
	var acctCurType=Ext.getCmp('acctCurType').getValue();
	var acctCurObj=Ext.getCmp('acctCurObj').getValue();

	var msg="";
	if(cmpID=="acctCurSubj"){
		if(acctYear==""){
			msg=msg+'�����Ȳ���Ϊ��! <br/>';
		}
	}else if(cmpID=="acctCurType"){
		if(acctYear==""){
			msg=msg+'�����Ȳ���Ϊ��! <br/>';
		}
		if(acctCurSubj==""){
			msg=msg+'������Ŀ����Ϊ��! <br/>';
		}
	}else if(cmpID=="acctCurObj"){
		if(acctYear==""){
			msg=msg+'�����Ȳ���Ϊ��! <br/>';
		}
		if(acctCurSubj==""){
			msg=msg+'������Ŀ����Ϊ��! <br/>';
		}
		if(acctCurType==""){
			msg=msg+'�������Ͳ���Ϊ��! <br/>';
		}
	}
	if(msg!=""){
		Ext.Msg.show({title:'����',msg:msg,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:'200'});
	}
}
});