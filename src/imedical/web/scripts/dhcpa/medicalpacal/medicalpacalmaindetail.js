
var userid=session['LOGON.USERID'];
var deptdr=session['LOGON.CTLOCID'];


//��ť
var dauditbutton = new Ext.Toolbar.Button({
   	        text : '���',
			iconCls : 'option',
			handler : function() {
			var rowObj = itemGridDetail.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if (len>0){
			 for(var i = 0; i < len; i++){

			 var  state=rowObj[0].get("auditstate");
		        if (!((state=="���ύ")||(state=="���δͨ��"))){
					Ext.Msg.show({title:'ע��',msg:state+'״̬�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
					return null;
				}else{
					 var result=30 ;
			    	 var rowid = rowObj[i].get("rowid"); 
		        	 var srowid=rowObj[i].get("srowid"); 
		       		 var state=rowObj[i].get("auditstate"); 
   
				//rowid, userdr,shemedr,result,chkprocdesc,desc,deptdr,chktype
		        Ext.Ajax.request({
				url:'dhc.pa.basedeptpacheckexe.csp?action=check&rowid='
				+rowid+"&userdr="+userid+"&schemedr="+srowid+"&result="+30+"&deptdr="+deptdr+"&desc="+encodeURIComponent(rowObj[i].get("desc")),
		
				waitMsg:'�����...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
		
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						itemGridDetail.load();
						itemGrid.load();
				}
				},
				scope: this
				});
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
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if (len>0){
			 for(var i = 0; i < len; i++){
			 var  state=rowObj[0].get("auditstate");
		        if (!((state=="���ύ")||(state=="���ͨ��"))){
				Ext.Msg.show({title:'ע��',msg:'��״̬�޷�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}  
			    else{
		        var rowid = rowObj[i].get("rowid"); 
		        var srowid=rowObj[i].get("srowid"); 
		        var state=rowObj[i].get("auditstate"); 

				//rowid, userdr,shemedr,result,chkprocdesc,desc,deptdr,chktype
		        Ext.Ajax.request({
				url:'dhc.pa.basedeptpacheckexe.csp?action=check&rowid='
				+rowid+"&userdr="+userid+"&schemedr="+srowid+"&result="+10+"&deptdr="+deptdr+"&desc="+encodeURIComponent(rowObj[i].get("desc")),		
				waitMsg:'ȡ�������...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
		
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'��˲�ͨ�����!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						itemGridDetail.load();
					itemGrid.load();
				}
				},
				scope: this
				});
			    }
		     }
			}
		
		}
		});

function renderTopic(value, p, record){
	    return String.format(
	    		"<b><a target=\"_blank\" href=\""+dhcReportUrl+"/runqianReport/report/jsp/dhccpmrunqianreport.jsp?cycleDr={1}&frequency={2}&period={3}&schemDr={4}&groupDr={5}&report=HERPJXLocSumReport.raq&reportName=HERPJXLocSumReport.raq&ServerSideRedirect=dhccpmrunqianreport.csp\">���˻��ܱ�</a></b>",
	            value, record.data.yearid,record.data.frequency,record.data.changedperiod,record.data.srowid,record.data.GroupDr
	            );
}

function renderBlue(value, p, record){
	    return String.format(
	    		"<font color=\"blue\"><b>"+value+"</b></font>",
	            value);
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
	         id:'yearid',
		     header: 'yearid',
		     allowBlank: false,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'yearid'
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
		     //editable:false,
		     dataIndex: 'desc'
		}, {
		
		     id:'auditstate',
		     header: '״̬',
		     allowBlank: false,
		     
		     width:100,
		     editable:false,
		     dataIndex: 'auditstate',
		     renderer:renderBlue

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
		},{
			id : 'GroupDr',
			header : '���ҷ���ID',
			align:'center',
			editable:false,
			width : 80,
			hidden : true,
			dataIndex : 'GroupDr'
			
		},{
			id : 'changedperiod',
			header : '������',
			align:'center',
			editable:false,
			hidden : true,
			width : 80,
			dataIndex : 'changedperiod'  
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
	if (columnIndex == 10) {
	var records = itemGridDetail.getSelectionModel().getSelections();
	
	var schemrowid = records[0].get("rowid");
	var title = records[0].get("name");
	StatesDetail(title,schemrowid);
	}
});
