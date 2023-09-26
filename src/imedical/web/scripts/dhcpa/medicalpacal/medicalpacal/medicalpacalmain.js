var userid=session['LOGON.USERID'];
var deptdr=session['LOGON.CTLOCID'];
var getFullMonth=function (date){
  if(date.getMonth()<10){
    return "0"+(date.getMonth()+1);
  }else{return date.getMonth()+1;}}
var yearField = new Ext.form.TextField({
	id: 'yearField',
	fieldLabel: '���',
	width:100,
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

var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '�ڼ�����',
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	anchor: '90%',
	value:'M', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'ѡ���ڼ�����...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

periodTypeField.on("select",function(cmb,rec,id){
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
	periodStore.loadData(data);
});
periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});
periodStore.loadData([['01','01��'],['02','02��'],['03','03��'],['04','04��'],['05','05��'],['06','06��'],['07','07��'],['08','08��'],['09','09��'],['10','10��'],['11','11��'],['12','12��']]);
var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '',
	value:getFullMonth(new Date()),
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodStore,
	anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'��ѡ��...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 12,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

//״̬
var stateStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['0','δ�ύ'],['10','���δͨ��'],['20','���ύ'],['30','���ͨ��'],['60','����'],['','����']]
});
var stateField = new Ext.form.ComboBox({
	id: 'state',
	fieldLabel: '״̬',
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	//allowBlank: false,
	store: stateStore,
	anchor: '90%',
	//value:'M', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'ѡ��״̬����...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

var auditbutton = new Ext.Toolbar.Button({
   	        text : '����',
			iconCls : 'option',
			handler : function() {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if (len>0){
			 for(var i = 0; i < len; i++){
			//
			 var mystore=itemGridDetail.getStore();
			 var len=mystore.getCount();
			 for(var j=0;j<len;j++){
				 record=mystore.getAt(j);
				 if(record.data.auditstate=="���δͨ��"){
					Ext.Msg.show({title:'ע��',msg:'�ӷ����������δͨ���޷�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
					return null;
					 }
				 }
			
			/*
			 var  state=rowObj[0].get("auditstate");
		        if (state!="���ͨ��"){
				Ext.Msg.show({title:'ע��',msg:'״̬�����ͨ���޷�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}  
			    else{var result=60 ;
			    	submitFun(itemGrid,result);
			    	}
			    	*/
			    
		     }
		     	var result=60 ;
			    	submitFun(itemGrid,result);
			}
		}
  });
  var unauditbutton = new Ext.Toolbar.Button({
   	        text : 'ȡ������',
			iconCls : 'option',
			handler : function() {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫȡ������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if (len>0){
			 for(var i = 0; i < len; i++){
			 var  state=rowObj[0].get("auditstate");
		        if (state!="����"){
				Ext.Msg.show({title:'ע��',msg:'״̬�Ƿ����޷�ȡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}  
			    else{var result=30 ;
			    	submitFun(itemGrid,result);
			    	}
		     }
			}
		}
  });

var findButton = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '��ѯ',
			iconCls:'option',
			handler : function() {
				var pattern=/^\d{4}$/;
				
				
				year=yearField.getValue();
				if(!pattern.test(year)){
					Ext.Msg.show({title:'ע��',msg:'��ݸ�ʽ��������λ��Ч����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
					return null;}
				
	
				type = periodTypeField.getValue();
	
				period = periodField.getValue();
	
				result=stateField.getValue();
				
				period=year+""+period

				itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								userdr: userid,
								type : type,
								period : period,
								result:result
							}
						});

			}
			
		})
		
var calbutton = new Ext.Toolbar.Button(
		{
			text : '����',
			tooltip : '����',
			iconCls : 'option',
			handler : function() {
				var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid"); 
		        var srowid=rowObj[0].get("srowid"); 
		        var state=rowObj[0].get("auditstate"); 
		        if (state!="���ͨ��"){
				Ext.Msg.show({title:'ע��',msg:'δ���ͨ���޷�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}    
				//rowid, userdr,shemedr,result,chkprocdesc,desc,deptdr,chktype
		        Ext.Ajax.request({
				url:'dhc.pa.basedeptpacheckexe.csp?action=calculaotr&rowid='
				+rowid+"&userdr="+userid+"&schemedr="+srowid+"&result="+60,
		
				waitMsg:'������...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
		
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'����ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});		
				}
				},
				scope: this
				});
			}
});
		
		
function renderTopic(value, p, record){
	    return String.format(
	    		"<b><a href=\""+dhcbaUrl+"/runqianReport/report/jsp/dhccpmrunqianreport.jsp?cycleDr={1}&frequency={2}&period={3}&schemDr={4}&report=HERPJXLocSumReport.raq&reportName=HERPJXLocSumReport.raq&ServerSideRedirect=dhccpmrunqianreport.csp\">���˻��ܱ�</a></b>",
	            value, record.data.yearid,record.data.frequency,record.data.period,record.data.srowid);
}
	
    function renderTopic2(value, p, record){
    	
        return String.format(
                '<b></b><a href="www.baidu.com" target="_self">lala</a>'
                );
    }
var itemGrid = new dhc.herp.Grid({
        title: 'ҽ�񴦼�Ч���˼���',
        width: 400,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'dhc.pa.medicalpacalexe.csp',	  
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [
        new Ext.grid.CheckboxSelectionModel({editable:false}),
        {
	         id:'rowid',
		     header: '����״̬id',
		     allowBlank: false,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'rowid'
		}, {
		     id:'period',
		     header: '������',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'period'
		}, {
		     id:'code',
		     header: '�������',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'code'
		}, {
		     id:'name',
		     header: '��������',
		     allowBlank: false,
		     width:160,
		     editable:false,
		     dataIndex: 'name'
		}, {
		 	 id:'nothing',
		     header: '���˻��ܱ�',
		     allowBlank: false,
		     width:150,
		     editable:false,
		     dataIndex: 'nothing',
		     renderer : renderTopic
		}, {
		     id:'auditdr',
		     header: '������',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     //hidden:true,
		     dataIndex: 'auditdr'
		}, {
		     id:'auditstate',
		     header: '״̬',
		     allowBlank: false,
		     
		     width:100,
		     editable:false,
		     dataIndex: 'auditstate'
		}, {
		     id:'desc',
		     header: '�������',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     hidden:true,
		     dataIndex: 'desc'
		}, {
		     id:'auditdate',
		     header: '�������',
		     allowBlank: false,
		     width:100,
		     //hidden:true,
		     editable:false,
		     dataIndex: 'auditdate'
		}, {
		     id:'srowid',
		     header: '����id',
		     allowBlank: false,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'srowid'

		}, {
		     id:'frequency',
		     header: '�ڼ�����',
		     allowBlank: false,
		     hidden:true,
		     width:100,
		     editable:false,
		     dataIndex: 'frequency'
		}, {
		     id:'upschemdr',
		     header: '�ϼ�����',
		     allowBlank: false,
		     hidden:true,
		     width:100,
		     editable:false,
		     dataIndex: 'upschemdr'
		}, {
		     id:'children',
		     header: '�ӿ��Ҳ���',
		     allowBlank: false,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'children',
		     renderer : renderTopic2
		}],
        
        tbar:['���',yearField,'�ڼ�����',periodTypeField,'�ڼ�',periodField,'״̬',stateField,findButton,auditbutton,'-',unauditbutton,'-',calbutton]
        
});
findButton.handler();

 //�����޸İ�ť��Ӧ����
auditHandler = function(){
		
       
};
itemGrid.btnAddHide() ;	//�������Ӱ�ť
itemGrid.btnSaveHide(); 	//���ر��水ť
itemGrid.btnResetHide(); 	//�������ð�ť
itemGrid.btnDeleteHide(); //����ɾ����ť
itemGrid.btnPrintHide() ;	//���ش�ӡ��ť

// ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//  ״̬

	var records = itemGrid.getSelectionModel().getSelections();
	var srowid = records[0].get("srowid");
	var period = records[0].get("period");
	itemGridDetail.load({
							params : {
								start : 0,
								limit : 25,
								userdr:userid,
								schemedr: srowid,
								period : period
							}
						});
	
});
// ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//  ״̬
	if (columnIndex == 8) {
	var records = itemGrid.getSelectionModel().getSelections();
	var schemrowid = records[0].get("srowid");
	var title = records[0].get("name");
	StatesDetail(title,schemrowid);
	}
});
