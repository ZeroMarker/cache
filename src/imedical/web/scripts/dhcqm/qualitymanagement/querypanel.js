userid=session['LOGON.USERID'];
var projUrl = '../csp/dhc.qm.qualityinfomanagementexe.csp';

//��ҳ���ܱ���
var allrecords=0,//��ҳ��
//onepagerecords=5,//ÿҳ��¼��
nowpage=0,//��ǰҳ
rowNum=0;//ÿҳ��ʾ������

var limit=10;
var maxpage=0;
var start=0;

var getFullPeriodType = function (date) {
  var d = date.getMonth();
  d=d/3+1;
  return "0"+parseInt(d);

}
var yearField2 = new Ext.form.TextField({
	id: 'yearField',
	fieldLabel:'���',
	width:50,
	regex: /^\d{4}$/,
	regexText:'���Ϊ��λ����',
	listWidth : 245,
	triggerAction: 'all',
	emptyText:'',
	name: 'yearField',
	value:(new Date()).getFullYear(),
	minChars: 1,
	pageSize: 10,
	editable:true
});

var periodTypeStore2 = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','��'],['Q','��']]
});
var periodTypeField2 = new Ext.form.ComboBox({
	id: 'periodTypeField',
	//fieldLabel: '�ڼ�����',
	width:50,
	listWidth : 50,
	selectOnFocus: true,
	resizable:true,
	//allowBlank: false,
	store: periodTypeStore2,
	anchor: '90%',
	value:'Q', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'ѡ���ڼ�����...',
	mode: 'local', //����ģʽ
	editable:false,
	//pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

periodTypeField2.on("select",function(cmb,rec,id){
	console.log(cmb.getValue());
	if(cmb.getValue()=="M"){
		data=[['01','01��'],['02','02��'],['03','03��'],['04','04��'],['05','05��'],['06','06��'],['07','07��'],['08','08��'],['09','09��'],['10','10��'],['11','11��'],['12','12��']];
	}
	if(cmb.getValue()=="Q"){
		data=[['01','01����'],['02','02����'],['03','03����'],['04','04����']];
	}
	if(cmb.getValue()=="H"){
		data=[['01','1~6�ϰ���'],['02','7~12�°���']];
	}
	if(cmb.getValue()=="Y"){
		data=[['00','ȫ��']];
	}
	periodStore2.loadData(data);
});
periodStore2 = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});
periodStore2.loadData([['01','01����'],['02','02����'],['03','03����'],['04','04����']]);
var periodField2 = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '',
	//value:(new Date()).getMonth()<10?"0"+((new Date()).getMonth()+1):((new Date()).getMonth()+1),
	value:'',
	width:80,
	listWidth :80,
	selectOnFocus: true,
	resizable:true,
	//allowBlank: false,
	store: periodStore2,
	anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'��ѡ��...',
	mode: 'local', //����ģʽ
	//editable:false,
	//pageSize: 12,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

var DeptDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','deptGroupCode','deptGroupName'])
});


DeptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetDeptField&str='+encodeURIComponent(Ext.getCmp('DeptField').getRawValue()),
	method:'POST'});
});

var DeptField = new Ext.form.ComboBox({
	id: 'DeptField',
	fieldLabel: '����',
	width:150,
	listWidth :200,
	resizable:true,
	
	//allowBlank: true,
	store:DeptDs,
	valueField: 'rowid',
	displayField: 'deptGroupName',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
	name: 'DeptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

DeptField.addListener('select',function(){
	wardDs.load({params:{start:0,limit:10,dept:DeptField.getValue()}});
});

//����
var wardDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'deptGroupDr', 'wardCode', 'wardName'])
		});
		
wardDs.on('beforeload', function(ds, o) {
	var deptdr=DeptField.getValue();
		if(deptdr==""){
			
			Ext.Msg.show({title:'����',msg:'����ѡ�����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return ;
		}
	
	
		ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.qm.qualityinfomanagementexe.csp'
							+'?action=ListwardDr&str='
							+ encodeURIComponent(Ext.getCmp('queryLocResultMainwardDr').getRawValue())+'&dept='+deptdr,
						method : 'POST'
					});
		});

var LocResultMainwardDr = new Ext.form.ComboBox({
	id: 'queryLocResultMainwardDr',
	fieldLabel: '����',
	width:200,
	emptyText:'��ѡ����...',
	listWidth : 200,
	resizable:true,
	allowBlank: false,
	store: wardDs,
	displayField: 'wardName',
	valueField: 'rowid',
	triggerAction: 'all',
	typeAhead : true,
	//triggerAction : 'all',

	name: 'LocResultMainwardDr',
	pageSize: 10,
	minChars: 1,
	forceSelection : true,
	selectOnFocus:true,
    editable:true
		});

//����
var checkDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
checkDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
					
						url : '../csp/dhc.qm.qualityinfomanagementexe.csp'
							+'?action=ListCheck&str='
							+ encodeURIComponent(Ext.getCmp('outLocResultdetailcheckDr').getRawValue())+'&schemdr='+encodeURIComponent(Ext.getCmp('SchemeField').getValue()),
						method : 'POST'
					});
		});
var LocResultdetailcheckDr = new Ext.form.ComboBox({
	id: 'outLocResultdetailcheckDr',
	fieldLabel: '����',
	width:200,
	listWidth : 200,
	resizable:true,
	allowBlank: false,
	store: checkDs,
	displayField: 'name',
	valueField: 'rowid',
	triggerAction: 'all',
	typeAhead : true,
	//triggerAction : 'all',
	emptyText : '��ѡ�����',
	name: 'LocResultdetailcheckDr',
	pageSize: 10,
	minChars: 1,
	forceSelection : true,
	selectOnFocus:true,
    editable:true
		});
var SchemeDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


SchemeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=ListschemDr&str='+encodeURIComponent(Ext.getCmp('SchemeField').getRawValue())+'&userid='+userid,
	method:'POST'});
});

var SchemeField = new Ext.form.ComboBox({
	id: 'SchemeField',
	fieldLabel: '�����ں�',
	width:220,
	listWidth : 220,
	resizable:true,
	//allowBlank: true,
	store:SchemeDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ�����ں�...',
	name: 'SchemeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
SchemeField.on("beforeselect",function(){
		var check=LocResultdetailcheckDr.getValue();
		
      	if(check!=""){
			LocResultdetailcheckDr.clearValue();
			
	    }
	});
SchemeField.addListener('select',function(){
	checkDs.load({params:{start:0,limit:10,schemdr:SchemeField.getValue()}});
});
function dosearchreport(){

				year=yearField.getValue();
				var pattern=/^\d{4}$/;
				if(pattern.test(year)==false){
					Ext.Msg.show({title:'ע��',msg:'��ݸ�ʽ��������λ��Ч����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
					return null;}
				
				
				type = periodTypeField.getValue();
				
				period = periodField.getValue();

				dept = DeptField.getValue();
				
				scheme=SchemeField.getValue();
				
				checkdr=LocResultdetailcheckDr.getValue();
				
				warddr=LocResultMainwardDr.getValue();
				
				
				var reporturl='dhccpmrunqianreport.csp?reportName=DHCJXQMQMInfoManagement.raq'+'&year='+year+'&type='+type+'&period'+period+'&dept'+dept+'&scheme'+scheme;
				reportpanel.update('<iframe id="frameReport" height="100%" width="100%" src="'+reporturl+'"/>');
	
	}
var searchButton = new Ext.Button({
					text : '��ѯ',
					
					width:80,
					iconCls : 'search',
					handler : function() {
					dosearch(0,limit,"","","");	
					}
				});

var insertButton = new Ext.Button({
					text : '���',
					
					width:80,
					iconCls : 'add',
					handler : function() {
						doadd(this);
					}
				});
var editButton = new Ext.Button({
					text : '�޸�',
					
					width:80,
					iconCls : 'edit',
					handler : function() {
						
						doedit(this);
					}
				});
var importButton = new Ext.Button({
	text : '����Excel�ļ�',
	tooltip : '����Excel�ļ�',
	width:120,
	iconCls : 'in',
	handler : function() {
		doimport();
	}
});
var auditButton = new Ext.Button({
					text : '���',
					
					width:80,
					iconCls : 'audit',
					handler : function() {
						doauditall(this,1,userid);
					}
				});
var unauditButton = new Ext.Button({
					text : 'ȡ�����',
					
					width:80,
					iconCls : 'cancel_audit',
					handler : function() {
						doauditall(this,2,userid);
					}
				});
				
/**
 * ����ӿ�����  2016-9-22 add cyl
*/				
var interfaceButton = new Ext.Button({
	text : '����ӿ�����',
	tooltip : '����ӿ�����',
	width:120,
	iconCls : 'in',
	handler : function() {
		doInterfaceFun();
	}
});				
				
				
var querypanel = new Ext.form.FormPanel({
        region:'north',
        //title   : 'Composite Fields',
        autoHeight: true,
        width   : 600,
        
        bodyStyle: 'padding: 5px',

        items   : [

            {	
            	xtype: 'compositefield',
                //fieldLabel: '��ѯ����',
                msgTarget : 'side',

                hideLabel: true,
                //anchor    : '-20',
                defaults: {
                    flex: 1
                },
                items: [
                	{xtype: 'displayfield', value: '��',width: 15},
                    yearField2,
                    periodTypeField2,
                    periodField2,
                    DeptField,
                    LocResultMainwardDr,
                    SchemeField,
                    LocResultdetailcheckDr
                ]
           
          
            }
            
            ,{
	                       	
            	xtype: 'compositefield',
                //fieldLabel: '��ѯ����',
                msgTarget : 'side',

                hideLabel: true,
                //anchor    : '-20',
                defaults: {
                    flex: 1
                },
                items: [
                
                	searchButton,
                	insertButton,
                	editButton,
                	importButton,
                	interfaceButton,
                	auditButton,
                	unauditButton,
                	{xtype: 'displayfield', value: '',width: 15}

                ] 
                
            
	        
	        
	        }
	        
        ]
		
    });
/*var allrecords=0,//��ҳ��
	onepagerecords=50,//ÿҳ��¼��
	nowpage=0,//��ǰҳ
	num=0;
;*/

var fisrtButton = new Ext.Button({
	text : '��ҳ',
	tooltip : '��ҳ',
	width:80,
	iconCls : 'option',
	handler : function() {
		nowpage=0;
		dosearch(0,limit);
	
	}
});
var previousButton = new Ext.Button({
	text : '��һҳ',
	tooltip : '��һҳ',
	width:80,
	iconCls : 'option',
	handler : function() {
		nowpage=nowpage>0?nowpage-1:0;
		dosearch(nowpage*limit+nowpage,limit);//20151222
	
	}
});
var nextButton = new Ext.Button({
	text : '��һҳ',
	tooltip : '��һҳ',
	width:80,
	iconCls : 'option',
	handler : function() {
		nowpage=nowpage<maxpage-1?nowpage+1:nowpage;
		//dosearch(nowpage*limit,limit);
		alert(nowpage*limit+nowpage);
		dosearch(nowpage*limit+nowpage,limit);//20151222
		
	}
});
var lastButton = new Ext.Button({
	text : 'βҳ',
	tooltip : 'βҳ',
	width:80,
	iconCls : 'option',
	handler : function() {
		nowpage=maxpage-1;
		dosearch(nowpage*limit+nowpage,limit);//20151222
	
	}
});

var showField=new Ext.form.DisplayField({xtype: 'displayfield', value: '<span size="14" width="200px">��'+maxpage+'ҳ,��ǰ��'+(nowpage+1)+'ҳ  ��ҳ��'+rowNum+'����¼.</span>',width:200});
var Pagepanel = new Ext.form.FormPanel({
    region:'south',
    //title   : 'Composite Fields',
    autoHeight: true,
    width   : 600,
    
    bodyStyle: 'padding: 5px',

    items   : [

        {	
        	xtype: 'compositefield',
            //fieldLabel: '��ѯ����',
            msgTarget : 'side',

            hideLabel: true,
            //anchor    : '-20',
            defaults: {
                flex: 1
            },
            items: [
                fisrtButton,
            	previousButton,
            	showField,
                nextButton,
                lastButton
            ]
       
      
        }
        
        
        
    ]
	
});



