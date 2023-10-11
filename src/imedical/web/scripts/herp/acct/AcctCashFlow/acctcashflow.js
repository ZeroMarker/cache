var acctbookid=	IsExistAcctBook();

var userdr = session['LOGON.USERID'];//��¼��ID

//var acctbookid=GetAcctBookID();

var projUrl = 'herp.acct.acctcashflowqueryexe.csp';

//������ʼʱ��ؼ�

Ext.ux.MonthPickerPlugin = function() {
    var picker;
    var oldDateDefaults;

    this.init = function(pk) {
        picker = pk;
        picker.onTriggerClick = picker.onTriggerClick.createSequence(onClick);
        picker.getValue = picker.getValue.createInterceptor(setDefaultMonthDay).createSequence(restoreDefaultMonthDay);
        picker.beforeBlur = picker.beforeBlur.createInterceptor(setDefaultMonthDay).createSequence(restoreDefaultMonthDay);
    };

    function setDefaultMonthDay() {
        oldDateDefaults = Date.defaults.d;
        Date.defaults.d = 1;
        return true;
    }

    function restoreDefaultMonthDay(ret) {
        Date.defaults.d = oldDateDefaults;
        return ret;
    }

    function onClick(e, el, opt) {
        var p = picker.menu.picker;
        p.activeDate = p.activeDate.getFirstDateOfMonth();
        if (p.value) {
            p.value = p.value.getFirstDateOfMonth();
        }

        p.showMonthPicker();
        
        if (!p.disabled) {
            p.monthPicker.stopFx();
            p.monthPicker.show();
            
            p.mun(p.monthPicker, 'click', p.onMonthClick, p);
            p.mun(p.monthPicker, 'dblclick', p.onMonthDblClick, p);
            p.onMonthClick = p.onMonthClick.createSequence(pickerClick);
            p.onMonthDblClick = p.onMonthDblClick.createSequence(pickerDblclick);
            p.mon(p.monthPicker, 'click', p.onMonthClick, p);
            p.mon(p.monthPicker, 'dblclick', p.onMonthDblClick, p);
        }
    }

    function pickerClick(e, t) {
        var el = new Ext.Element(t);
        if (el.is('button.x-date-mp-cancel')) {
            picker.menu.hide();
        } else if(el.is('button.x-date-mp-ok')) {
            var p = picker.menu.picker;
            p.setValue(p.activeDate);
            p.fireEvent('select', p, p.value);
        }
    }

    function pickerDblclick(e, t) {
        var el = new Ext.Element(t);
        if (el.parent()
            && (el.parent().is('td.x-date-mp-month')
            || el.parent().is('td.x-date-mp-year'))) {

            var p = picker.menu.picker;
            p.setValue(p.activeDate);
            p.fireEvent('select', p, p.value);
        }
    }
};
Ext.preg('monthPickerPlugin', Ext.ux.MonthPickerPlugin);

//����ڼ�
var startYearMonth = new Ext.form.DateField({
    id:'startYearMonth',
    fieldLabel: '����ڼ�',
    name : 'STARTYEAR_MONTH',
    format : 'Y-m',
    editable : true,
    allowBlank : false,
    emptyText:'��ѡ������...',
   // value:new Date(),
    width: 120,
   // maxValue : new Date(),
    plugins: 'monthPickerPlugin'
    // listeners : {
        // scope : this,
        // 'select' : function(dft){
        // }
    // }
});

var endYearMonth = new Ext.form.DateField({
    id:'endYearMonth',
     fieldLabel: '����ڼ�',
    name : 'ENDYEAR_MONTH',
    format : 'Y-m',
    editable : true,
    allowBlank : false,
   // emptyText:'��ѡ������...',
    width: 120,
  //  maxValue : new Date(),
    plugins: 'monthPickerPlugin'
    // listeners : {
        // scope : this,
        // 'select' : function(dft){
        // }
    // }
});




//�ֽ�������
var cashflowDS=new Ext.data.Store({
    autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({
	totalProperty:'results',
	root:'rows'},
	['rowid','name','Code'])
	
});

cashflowDS.on('beforeload', function(ds, o){

	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=getcashflow&acctbookid='+acctbookid+'&str='+encodeURIComponent(Ext.getCmp('CashFlowItem').getRawValue()),method:'POST'
	});
});

var CashFlowItem=new Ext.form.ComboBox({
 id:'CashFlowItem',
 fieldLabel:'�ֽ�������',
 width:215,
 listWidth:300,
 allowBlank:true,
 store:cashflowDS,
 valueField:'Code',
 displayField:'name',
 triggerAction:'all',
 //emptyText:'��ѡ���ֽ�������',
 name: 'CashFlowItem',
 minChars: 1,
 pageSize: 10,
 selectOnFocus:true,
 forceSelection:'true',
 editable:true,
 resizable:true
 
});

//�ʽ�����

var CFDirectionDS=new Ext.data.SimpleStore({
      fields : ['key', 'keyValue'],
	  data : [['0', '����'],['1', '����']]
});

//����������  �ʽ�����
var CashDirection=new Ext.form.ComboBox({
   id:'CashDirection',
   fieldLabel : '�ʽ�����',
	width : 120,
	listWidth : 100,
	store : CFDirectionDS,
	valueNotFoundText : '',
	displayField : 'keyValue',
	valueField : 'key',
	mode : 'local', // ����ģʽ
	triggerAction: 'all',
	//emptyText:'ȫ��',
	selectOnFocus:true,
	forceSelection : true,
	editable:true
	//allowBlank:true
	
});

  //----------------- ����δ����-----------------//
    var isAcct = new Ext.form.Checkbox({
    	fieldLabel : '����δ����',
		id : 'isAcct',
		name : 'isAcct',
		style:'border:0;background:none;margin-top:0px;',
	   labelAlign:'right'
    });

    var QueryButton=new Ext.Toolbar.Button({
            text : '��ѯ',
		tooltip : '��ѯ',
		iconCls:'find',
		handler:function(){
		
			
		var startacctYearMonth=startYearMonth.getValue();
		  if(startacctYearMonth!=""){
			 
		  	 var startacctYearMonth=startacctYearMonth.format('Ym');
			// alert(startacctYearMonth);
		   	 }
            
            var endacctYearMonth=endYearMonth.getValue();
               if(endacctYearMonth!=""){
			 var endacctYearMonth=endacctYearMonth.format('Ym');
			
			 }else{
				 var endacctYearMonth="";
				 }
				 
	            
             if(endacctYearMonth!=""&&(startacctYearMonth>endacctYearMonth)){
	        
	           Ext.Msg.show({
					title:'��ʾ',
					msg:' ��ʼ���²��ܴ��ڽ�������,����������.. ',
					buttons:Ext.Msg.OK,
					icon:Ext.MessageBox.WARNING
				});
	            return;
	          }
	       
	       if(startacctYearMonth==""){
		       Ext.Msg.show({
					title:'��ʾ',
					msg:' ���������ڼ俪ʼ�·� ',
					buttons:Ext.Msg.OK,
					icon:Ext.MessageBox.WARNING
				});
		       
	            return;
		       }
				 
            
          var AcctCashFlowItemIDs=CashFlowItem.getValue();
          var CFDirections=CashDirection.getValue();
          
          var isAcct1=isAcct.getValue();
          
             
        	if(isAcct1==true){
			isAcctss=1;
		}else{
			isAcctss=0;
		}
		
		
            itemGrid.load({
		    params:{
		
			sortField:'',
			sortDir:'',
		    start:0,
		    limit:25,
			AcctCashFlowItemID:AcctCashFlowItemIDs,
			CFDirection:CFDirections,
			isAccts:isAcctss,
			userdr:userdr,
			acctbookid:acctbookid,
			startacctYearMonth:startacctYearMonth,
			endacctYearMonth:endacctYearMonth
			}
	  });			
		}
		
    });
   
   var query=new Ext.FormPanel({
	    title: '�ֽ�������ϸ��ѯ',
		iconCls:'find',
		region: 'north',
		height: 70,
		frame: true,
		defaults: {
			bodyStyle: 'padding:5px '
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				hideLabel: true,
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '����ڼ�',
						style: 'line-height: 15px;',
						width: 60
					}, startYearMonth, {
						xtype: 'displayfield',
						value: '��',
						style: 'line-height: 15px;',
						width: 20
					}, endYearMonth, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '�ֽ�������',
						style: 'line-height: 15px;',
						width: 80
					}, CashFlowItem, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '�ʽ�����',
						style: 'line-height: 15px;',
						width: 60
					}, CashDirection, {
						xtype: 'displayfield',
						value: '',
						width: 15
					},{
						xtype: 'displayfield',
						value: '����δ����',
						style: 'line-height: 15px;',
						width: 80
					},
					isAcct,{
						xtype: 'displayfield',
						value: '',
						width: 15
					},QueryButton
				]
				}]
	   
   });
   
    var itemGrid = new dhc.herp.Grid({
		    title:'�ֽ�������ϸ��ѯ�б�',
		    iconCls:'list',
            width: 400,
			region: 'center',
			url : projUrl,	
			atLoad:true, 
			//forceFit:true,
			readerModel:'remote',
			//tbar:['����ڼ�:',startYearMonth,'��',endYearMonth,'-','�ֽ�������:',CashFlowItem,'-','�ʽ�����:',CashDirection,'-','����δ����:',isAcct,'-',QueryButton],
			fields : [
			
				{
				id:'CashItemName',
				header:'<div style="text-align:center">�ֽ���������</div>',
				width:350,
				editable : false,
				align:'left',
				allowBlank : false,  
				dataIndex : 'CashItemName'
				},
				{
				  id:'CFDirection',
				  header:'<div style="text-align:center">����</div>',
				  width : 60,
				  align:'center',
				  editable : false,
				  allowBlank : true,     
				  dataIndex : 'CFDirection'
				},
				{
				  id:'amount',
				  header:'<div style="text-align:center">���</div>',
				  width : 120,
				  align:'right',
				  editable : false,
				  allowBlank : true,     
				  dataIndex : 'amount'
				},
				{
				  id:'VouchNo',
				  header:'<div style="text-align:center">ƾ֤��</div>',
				  width : 150,
				  align:'center',
				  editable : false,
				  allowBlank : true,  
				  renderer:function(value,cellmeta,record,rowIndex,columnIndex,store){
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>'	
						},   
				  dataIndex : 'VouchNo'
				},
				{
				  id:'VouchState1',
				  header:'<div style="text-align:center">VouchState1</div>',
				  width : 90,
				  align:'center',
				  editable : false,
				  allowBlank : true, 
				  hidden:true,       
				  dataIndex : 'VouchState1'
				},
				{
				  id:'VouchState',
				  header:'<div style="text-align:center">ƾ֤״̬</div>',
				  width : 90,
				  align:'center',
				  editable : false,
				  allowBlank : true, 
				  hidden:true,       
				  dataIndex : 'VouchState'
				},
				{
				  id:'VouchDate',
				  header:'<div style="text-align:center">ҵ������</div>',
				  width : 90,
				  align:'center',
				  editable : false,
				  allowBlank : true,  
				  dataIndex : 'VouchDate'
				},
				{
				 id:'AcctSubjName',
				 header:'<div style="text-align:center">��ƿ�Ŀ</div>',
				 width : 150,
				 align:'left',
				 editable : false,
				 allowBlank : true,     
				 dataIndex : 'AcctSubjName'
				},
				{
				  id:'Summary',
				  header:'<div style="text-align:center">ժҪ</div>',
				  width : 170,
				  align:'left',
				  editable : false,
				  allowBlank : true,     
				  dataIndex : 'Summary'
				},
				{
				 id:'Poster',
				 header:'<div style="text-align:center">������</div>',
				 width : 100,
				  align:'left',
				  editable : false,
				  allowBlank : true,     
				  dataIndex : 'Poster'
				},
				{
				 id:'PostDate',
				 header:'<div style="text-align:center">����ʱ��</div>',
				 width : 100,
				  align:'center',
				  editable : false,
				  allowBlank : true,     
				  dataIndex : 'PostDate'
				}]
    });
    
    
    
    itemGrid.load({
	    params:{
		    start:0,
		    limit:25,
		    userdr:userdr,
		    acctbookid:acctbookid
		    }
		    });	
		    
     itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
        
	    if(columnIndex=='4'){
			//p_URL = 'acct.html?acctno=2';
		    //document.getElementById("frameReport").src='acct.html';
			var records = itemGrid.getSelectionModel().getSelections();   
			var VouchNo = records[0].get("VouchNo");
			var VouchState = records[0].get("VouchState1");
			var myPanel = new Ext.Panel( {
			layout : 'fit',
			//scrolling="auto"
			html : '<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno='+VouchNo+'&user='+userdr+'&acctstate='+VouchState+'&bookID='+acctbookid+'&SearchFlag='+'1'+'" /></iframe>'
			//frame : true
			});
			var win = new Ext.Window({
						title : 'ƾ֤�鿴',
						width :1090,
						height :620,
						resizable : false,
						closable : true,
						draggable : true,
						resizable : false,
						layout : 'fit',
						modal : false,
						plain : true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
						//bodyStyle : 'padding:5px;',
						items : [myPanel],
						buttonAlign : 'center',
						buttons : [{
								text : '�ر�',
								type : 'button',
								handler : function() {
									win .close();
									}
								}]
					});
					win.show();
	    }
     });
    itemGrid .btnAddHide();
    itemGrid.btnSaveHide();
    itemGrid.btnResetHide();
    itemGrid.btnDeleteHide();
    itemGrid.btnPrintHide();
	
 function getYear(){
    
    Ext.Ajax.request({
        url:'../csp/herp.acct.acctcashflowqueryexe.csp?action=GetAcctCurYearMonth&acctbookid='+ acctbookid,
        method: 'GET',
        success: function(result, request) {
        var jsonData = Ext.util.JSON.decode( result.responseText );
        if (jsonData.success=='true'){
			rtndata= (jsonData.info);
            //alert(rtndata);			
			startYearMonth.setValue(jsonData.info+"-01");
			
                  }
             }
			 
});
}
	getYear();