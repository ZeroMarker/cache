
var userid=session['LOGON.USERID'];
var deptdr=session['LOGON.CTLOCID'];


//�ύ��ť
var dauditbutton = new Ext.Toolbar.Button({
   	        text : '���',
			iconCls : 'option',
			handler : function() {
			var rowObj = itemGridDetail.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�ύ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if (len>0){
			 for(var i = 0; i < len; i++){
			 var  state=rowObj[0].get("auditstate");
		        if (state!="���ύ"){
				Ext.Msg.show({title:'ע��',msg:'״̬�����ύ�޷����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}  
			    else{var result=30 ;
			    	submitFun(itemGridDetail,result);
			    	}
		     }
			}
		}
  });

var dunauditbutton = new Ext.Toolbar.Button(
		{
		 	text : '��˲�ͨ��',
			iconCls : 'option',
			handler : function() {
			var rowObj = itemGridDetail.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�ύ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if (len>0){
			 for(var i = 0; i < len; i++){
			 var  state=rowObj[0].get("auditstate");
		        if (state!="���ύ"){
				Ext.Msg.show({title:'ע��',msg:'״̬�����ύ�޷����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}  
			    else{var result=10 ;
			    	submitFun(itemGridDetail,result);
			    	}
		     }
			}
		}
		});


function renderTopic(value, p, record){
	    return String.format(
	    		"<b><a href=\""+dhcbaUrl+"/runqianReport/report/jsp/dhccpmrunqianreport.jsp?cycleDr={1}&frequency={2}&period={3}&schemDr={4}&report=HERPJXLocSumReport.raq&reportName=HERPJXLocSumReport.raq&ServerSideRedirect=dhccpmrunqianreport.csp\">���˻��ܱ�</a></b>",
	            value, record.data.yearid,record.data.frequency,record.data.period,record.data.srowid);
}

var itemGridDetail= new dhc.herp.Gridwolf({
        title: '������Ҽ�Ч���˽�����',
        width: 400,
        edit:true, 
        height:300,                  //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'south',
        url: 'dhc.pa.basedeptpacheckexe.csp',	  
		//atLoad : true, // �Ƿ��Զ�ˢ��
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
		     hidden:true,
		     dataIndex: 'auditdr'
		}, {
		     id:'desc',
		     header: '�������',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'desc'
		}, {
		
		     id:'auditstate',
		     header: '״̬',
		     allowBlank: false,
		     
		     width:100,
		     editable:false,
		     dataIndex: 'auditstate'

		}, {
		     id:'auditdate',
		     header: '�������',
		     allowBlank: false,
		     width:100,
		     hidden:true,
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
		}],
        
        tbar:[dauditbutton,'-',dunauditbutton]

});


 //�����޸İ�ť��Ӧ����
auditHandler = function(){
		
       
};

itemGridDetail.btnAddHide();    //�������Ӱ�ť
itemGridDetail.btnSaveHide();   //���ر��水ť
itemGridDetail.btnDeleteHide(); //����ɾ����ť

// ����gird�ĵ�Ԫ���¼�
itemGridDetail.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//  ״̬
	if (columnIndex == 9) {
	var records = itemGridDetail.getSelectionModel().getSelections();
	var schemrowid = records[0].get("srowid");
	var title = records[0].get("name");
	StatesDetail(title,schemrowid);
	}
});
