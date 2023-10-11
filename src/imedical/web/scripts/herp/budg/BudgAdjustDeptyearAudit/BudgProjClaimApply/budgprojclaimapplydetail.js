var userid = session['LOGON.USERID'];
var projUrl2 = 'herp.budg.budgprojclaimapplydetailexe.csp';

//////////////// ��Ӱ�ť  ////////////////
var addButton = new Ext.Toolbar.Button({
	text: '���',
    tooltip:'���',        
    iconCls:'add',
	handler:function(){
	
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	var len = selectedRow.length;

		if (len < 1) {
			Ext.Msg.show({
						title : 'ע��',
						msg : '����ѡ��һ����Ŀ!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		}
		
	 var projDr=selectedRow[0].data['rowid'];      // ��ĿID
	 var Username=selectedRow[0].data['username']; // �û���
	 var projName=selectedRow[0].data['name'];     // ��Ŀ����
	 var deptdr=selectedRow[0].data['deptdr'];     // ����ID
	 var deptname=selectedRow[0].data['deptname']; // ��������
	 var year=selectedRow[0].data['year'];
	 
	 AddFun(itemDetail,projDr,projName,userid,Username,deptdr,deptname,year);
	 }
});

var UploadButton = new Ext.Toolbar.Button({
    text:'�ϴ�ͼƬ',
    tooltip:'�ϴ�ͼƬ',
    iconCls:'upload',
    //width : 70,
    //height : 30,
    handler:function(){
    
        var rowObj = itemDetail.getSelectionModel().getSelections(); 
        var len = rowObj.length;
        var message="��ѡ���Ӧ�ĵ��ݣ�";  
        if(len < 1){
            Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            return false;
        }else{
            var rowid = rowObj[0].get('rowid');
            var dialog = new Ext.ux.UploadDialog.Dialog({
            url: 'herp.budg.budgprojclaimapplydetailexe.csp?action=Upload&rowid='+rowid,
            reset_on_hide: false, 
            permitted_extensions:['gif','jpeg','jpg','png','bmp'],
            allow_close_on_upload: true,
            upload_autostart: false,
            title:'�ϴ�������ϢͼƬ'
            //post_var_name: 'file'
      });
      dialog.show();
        }
    }
});

var itemDetail = new dhc.herp.Gridapplydetail({
            title: '�������뵥',
			region : 'center',
			url : projUrl2,		
            tbar:[addButton,'-',UploadButton],
			fields : [{
						header : '֧������ID',
						dataIndex : 'rowid',
						hidden : true
					  },{
				        id:'projdr',
				        header: '��ĿID',
				        dataIndex: 'projdr',
				        width:90,
				        allowBlank: true,
						hidden: true
				      },{
						id : 'submit',
						header : 'ѡ��',
						dataIndex : 'submit',
						width : 100,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store){ 
						return '<span style="color:blue;cursor:hand"><BLINK id="submit"     onclick=submits();>      �ύ  </BLINK></span>'+'<b> </b>'
						+'<span style="color:blue;cursor:hand"><BLINK id="revocation" onclick=back();>  ����  </BLINK></span>'+'<b> </b>'
						+'<span style="color:blue;cursor:hand"><BLINK id="delete"     onclick=del();>       ɾ��  </BLINK></span>'+'<b> </b>' 
						}
					},{
						id : 'code',   //4
						header : '��������',
						width : 120,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'code'

					},{
						id : 'name',   //5
						header : '��Ŀ����',
						editable:false,
						width : 200,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'name'

					},{
						id : 'deptname',
						header : '��������',
						editable:false,
						width : 120,
						dataIndex : 'deptname'

					},{
						id : 'username',
						header : '������',
						width : 100,
						editable:false,
						dataIndex : 'username'

					},{
						id : 'ApplyDate',
						header : '����ʱ��',
						width : 100,
						editable : false,
						align:'right',
						dataIndex : 'ApplyDate'
						
					},{
						id : 'Desc',
						header : '����˵��',
						width : 120,
						editable:false,
						dataIndex : 'Desc'

					},{
						id : 'Actmoney',
						header : '�������',
						width : 120,
						editable : false,
						align:'right',
						dataIndex : 'Actmoney'
						
					},{
						id : 'FundTotal',
						header : 'Ԥ���ܶ�',
						width : 120,
						editable : false,
						dataIndex : 'FundTotal',
						hidden : true
						
					},{
						id : 'ActPayWait',
						header : '��;����',
						width : 120,
						align : 'right',
						editable:false,
						dataIndex : 'ActPayWait',					
						hidden : true

					},{
						id : 'ActPayMoney',
						header : '�Ѿ�ִ��',
						width : 120,
						align : 'right',
						editable:false,
						dataIndex : 'ActPayMoney',
						hidden : true

					},{
						id : 'ReqMoney',
						header : '�����ʽ�',
						width : 120,
						align : 'right',
						editable:false,
						dataIndex : 'ReqMoney',
						hidden : true

					},{
						id : 'budgco',
						header : 'Ԥ�����',
						width : 120,
						editable:false,
						align:'right',
						dataIndex : 'budgco'

					},{
						id : 'budgcotrol',
						header : 'Ԥ�����',
						width : 100,
						editable:false,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['budgcotrol']
						if (sf == "����Ԥ��") {
							return '<span style="color:red;cursor:hand;">'+value+'</span>';
						} else {
							return '<span style="color:black;cursor:hand">'+value+'</span>';
						}},
						dataIndex : 'budgcotrol'

					},{
						id : 'BillState',    
						header : '����״̬',
						width : 100,
						align : 'center',
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['BillState']
						if (sf == "�½�") {
							return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
						} else if (sf == "�ύ"){
							return '<span style="color:brown;cursor:hand"><u>'+value+'</u></span>';
						}else {
							return '<span style="color:black;cursor:hand"><u>'+value+'</u></span>';
						}},
						dataIndex : 'BillState'

					},{
						id : 'FundBillDR',
						header : '�ʽ����뵥ID',
						width : 100,
						editable:true,
						dataIndex : 'FundBillDR',
						hidden : true

					},{
						id : 'facode',
						header : '���뵥���',
						width : 120,
						editable:true,
						dataIndex : 'facode',
						hidden : true

					},{
						id : 'fadesc',
						header : '����˵��',
						width : 120,
						editable:true,
						dataIndex : 'fadesc',
						hidden : true

					},{
						id : 'codedesc',
						header : '�ʽ����뵥',
						width : 100,
						editable:true,
						dataIndex : 'codedesc',
						hidden : true
					},{
						id : 'File',
						header : '����ͼƬ',
						width : 100,
						editable:true,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
			 			},
						dataIndex : 'File'
					}],

					xtype : 'grid',
					loadMask : true,				
					atLoad: true
		});

//itemDetail.load({params:{start:0, limit:12,userid:userid}});
del = function(){
var selectedRow = itemGrid.getSelectionModel().getSelections();
         var selectedRow = itemDetail.getSelectionModel().getSelections();		
         var rowid	 = selectedRow[0].data['rowid'];
         var BillState  = selectedRow[0].data['BillState'];
         if(BillState=="�ύ"||(BillState=="ͨ��")||(BillState=="��ͨ��"))
         {alert("���뵥���ύ��������ɾ����");}
         else{
	    Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������Ŀ��', function(btn) {
		if (btn == 'yes') {
			var selectedRow = itemGrid.getSelectionModel().getSelections();
			var projdr=selectedRow[0].data['rowid'];
			Ext.Ajax.request({
				url: projUrl2+'?action=Del&rowid='+rowid+'&userid='+userid,
				waitMsg : '������...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '����',
								msg : '������������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({
								title : '',
								msg : 'ɾ���ɹ�',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
					}
				},
				scope : this
			});
		itemGrid.load({params:{start:0, limit:25,userid:userid}});
		itemDetail.load({params:{start:0, limit:25,userid:userid,projdr:projdr}});
		
		}
	});}
};
  
back=function(){
var selectedRow = itemDetail.getSelectionModel().getSelections();
	var selectedRow = itemDetail.getSelectionModel().getSelections();		
		var rowid	 = selectedRow[0].data['rowid'];
         var BillState  = selectedRow[0].data['BillState'];
         if(BillState=="�ύ"||(BillState=="ͨ��")||(BillState=="��ͨ��"))
         {  
	    Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ����ѡ������Ŀ��', function(btn) {
		if (btn == 'yes') {
			var selectedRow = itemGrid.getSelectionModel().getSelections();
			var projdr=selectedRow[0].data['rowid'];
			Ext.Ajax.request({
				url: projUrl2+'?action=unsubmit&rowid='+rowid+'&userid='+userid,
				waitMsg : '������...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '����',
								msg : '������������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({
								title : '',
								msg : '�����ɹ�',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
					}
				},
				scope : this
			});
		itemGrid.load({params:{start:0, limit:25,userid:userid}});
		itemDetail.load({params:{start:0, limit:25,userid:userid,projdr:projdr}});
		
		}
	});
         }     
        else if(BillState=="�½�"){
	        alert("���뵥δ�ύ,���ܳ�����");
	        }
	

};


submits=function(){

    var records = itemDetail.getSelectionModel().getSelections();
	var rowid = records[0].get("rowid")
	var BillState=records[0].get("BillState")
		
	if(BillState=="�ύ"||(BillState=="ͨ��")||(BillState=="��ͨ��"))
	{
		Ext.Msg.show({
						title : '',
						msg : '���ύ�ĵ��������ٴ��ύ',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
		return;
	}
	
	Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ�ύѡ������Ŀ��', function(btn) {
		if (btn == 'yes') {
			var selectedRow = itemGrid.getSelectionModel().getSelections();
			var projdr=selectedRow[0].data['rowid'];
			Ext.Ajax.request({
				url: projUrl2+'?action=submit&rowid='+rowid+'&userid='+userid,
				waitMsg : '������...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '����',
								msg : '������������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({
								title : '',
								msg : '�ύ�ɹ�',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
					}
				},
				scope : this
			});
	itemGrid.load({params:{start:0, limit:25,userid:userid}});
		itemDetail.load({params:{start:0, limit:25,userid:userid,projdr:projdr}});
			
		}
		
	});

};

//////////////////// ����gird�ĵ�Ԫ���¼�  //////////////////
itemDetail.on('cellclick', function(g, rowIndex, columnIndex, e) {
 //////////////////  ������������  ///////////////////////   
	if (columnIndex == 4) {	
	applynofun(itemDetail);	
	//rowid,projdr,code,deptname,username,name,Desc,facode,oldfundbilldr,BillState
	}
/////////////// ������Ŀ���� ///////////////
	if (columnIndex == 5) {
		var records = itemDetail.getSelectionModel().getSelections();
		var Name		 = records[0].get("name");
		var projdr		 = records[0].get("projdr");
		projnamefun("",projdr,Name);
	}
	
////////////////// ��������״̬  ////////////////
	if (columnIndex == 17) {
		var records = itemDetail.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var Code  		 = records[0].get("code");
		var Name		 = records[0].get("name");
		statefun(FundBillDR,Code,Name);
	}
	
		//����ͼƬ����ʾ
	//alert(columnIndex)
if (columnIndex == 22) {
		var records = itemDetail.getSelectionModel().getSelections();
		var rowid   = records[0].get("rowid");
		projpayuploadFun(rowid);
	}
	
/*////////////////// �����ύ /////////////////////
	if (columnIndex == 3) {
	var records = itemDetail.getSelectionModel().getSelections();
	var rowid = records[0].get("rowid")
	var BillState=records[0].get("BillState")
		
	if(BillState != "�½�")
	{
		Ext.Msg.show({
						title : '',
						msg : '���ύ�ĵ��������ٴ��ύ',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
		return;
	}
	
	Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ�ύѡ������Ŀ��', function(btn) {
		if (btn == 'yes') {
			var selectedRow = itemGrid.getSelectionModel().getSelections();
			var projdr=selectedRow[0].data['rowid'];
			Ext.Ajax.request({
				url: projUrl2+'?action=submit&rowid='+rowid+'&userid='+userid,
				waitMsg : '������...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '����',
								msg : '������������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({
								title : '',
								msg : '�ύ�ɹ�',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
					}
				},
				scope : this
			});
		itemGrid.load({params:{start:0, limit:25,userid:userid}});
		itemDetail.load({params:{start:0, limit:25,userid:userid,projdr:projdr}});
		
		}
	});
 }	*/
});





