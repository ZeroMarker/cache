var projUrl = 'herp.srm.srmprojectsinfoexe.csp';
               

var userdr = session['LOGON.USERCODE'];
//var username = session['LOGON.USERCODE'];

var groupdesc = session['LOGON.GROUPDESC'];
if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{ var userdr=""
}
if (groupdesc=="���й���ϵͳ(��Ϣ��ѯ)")
{ var userdr=""
}


Date.dayNames = ["��", "һ", "��", "��", "��", "��", "��"];  
    Date.monthNames=["1��","2��","3��","4��","5��","6��","7��","8��","9��","10��","11��","12��"];  
    if (Ext.DatePicker) {  
        Ext.apply(Ext.DatePicker.prototype, {  
            todayText: "����",  
            minText: "��������С����֮ǰ",  
            maxText: "�������������֮��",  
            disabledDaysText: "",  
            disabledDatesText: "",  
            monthNames: Date.monthNames,  
            dayNames: Date.dayNames,  
            nextText: '���� (Control+Right)',  
            prevText: '���� (Control+Left)',  
            monthYearText: 'ѡ��һ���� (Control+Up/Down ���ı���)',  
            todayTip: "{0} (Spacebar)",  
            okText: "ȷ��",  
            cancelText: "ȡ��" 
        });  
    } 	   

///////////////////����/////////////////////////////  
var TypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'],['2', '��ѧ']]
	});		
		
var TypeCombox = new Ext.form.ComboBox({
	                   id : 'TypeCombox',
		           fieldLabel : '����',
	                   width : 120,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : TypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true
						  });		
// ������ʼʱ��ؼ�
	var PSField = new Ext.form.DateField({
		id : 'PSField',
		//format : 'Y-m-d',
		width : 120,
		//allowBlank : false,
		emptyText : ''
	});

	var PEField = new Ext.form.DateField({
		id : 'PEField',
		//format : 'Y-m-d',
		width : 120,
		//allowBlank : false,
		emptyText : ''
	});
	
 ///��������
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
deptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=deptList&str='+encodeURIComponent(Ext.getCmp('deptCombo').getRawValue()), 
                        method:'POST'
					});
		});

var deptCombo = new Ext.form.ComboBox({
			id:'deptCombo',
			fieldLabel : '��������',
			store : deptDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

 ///������Դ
var SubSourceDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});
		
SubSourceDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=sourceList&str='+encodeURIComponent(Ext.getCmp('SubSourceCombo').getRawValue()), 
                        method:'POST'
					});
		});

var SubSourceCombo = new Ext.form.ComboBox({
			id:'SubSourceCombo',
			fieldLabel : '������Դ',
			store : SubSourceDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

///////////////////��Ŀ״̬
var PrjStateStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '�½�'],['1', '����'], ['2', 'ִ��'],['3','����'],['4','ȡ��']]
		});
var PrjStateField = new Ext.form.ComboBox({
			fieldLabel : '��Ŀ״̬',
			width : 120,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : false,
			store : PrjStateStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
///////////////////�����������
var ChkResultStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '�ȴ�����'], ['1', 'ͨ��'], ['2', '��ͨ��']]
		});
var ChkResultField = new Ext.form.ComboBox({
			fieldLabel : '�����������',
			width : 120,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : true,
			store : ChkResultStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : true,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
//////���⸺����
var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList',
						method : 'POST'
					});
		});

var userCombo = new Ext.form.ComboBox({
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		
// ////////////��������
var titleText = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});
//���뾭��
var grafundsField = new Ext.form.NumberField({
	id: 'grafundsField',
	fieldLabel: '��׼���',
	width:90,
	allowBlank: false,
	emptyText:'',
	name: 'grafundsField',
	editable:true
});

/////////////////// ��ѯ��ť 
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'find',
	handler: function(){
	    
		var startdate= PSField.getValue();
	    if (startdate!=="")
	    {
	       //startdate=startdate.format ('Y-m-d');
	    }
	    var enddate= PEField.getValue();
	    if (enddate!=="")
	    {
	       //enddate=enddate.format ('Y-m-d');
	    }
	    var dept  = deptCombo.getValue();
	    var SubSource= SubSourceCombo.getValue();
	    var projStatus  = PrjStateField.getValue();
	    var HeadDr= userCombo.getValue();
	    var PName = titleText.getValue();   
	    //var ResAudit = ChkResultField.getValue();
		var Type = TypeCombox.getValue();
	    var ResAudit = "";
		srmprjitemGrid.load({
		    params:{
		    start:0,
		    limit:25,   
		    ApplyStart: startdate,
		    Applyend: enddate,
		    deptdr: dept,
		    SubSource: SubSource,
		    HeadDr: HeadDr,
		    PName: PName,
		    ResAudit :ResAudit,
		    userdr:userdr,
			Type:Type
		   }
	  })
  }
});

///////////////////��Ӱ�ť///////////////////////
var addPatentInfoButton = new Ext.Toolbar.Button({
		text: '���',
    	tooltip: '����µ���Ŀ�������',        
    	iconCls: 'add',
		handler: function(){
			addFun()}
});

/////////////////�޸İ�ť/////////////////////////
var editPatentInfoButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		tooltip: '�޸�ѡ������Ŀ�������',
		iconCls: 'option',
		handler: function(){
			var rowObj = srmprjitemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				var state = rowObj[0].get("DataStatuslist");	
				var chkstate = rowObj[0].get("ChkResult");	
				var ParticipantsIDs = rowObj[0].get("ParticipantsIDs");
				var RelyUnitsIDs = rowObj[0].get("RelyUnitIDs");
				//alert(InventorsIDs);			
				if((state == "δ�ύ")||(groupdesc=="���й���ϵͳ(��Ϣ�޸�)" )||((state == "���ύ")&&(chkstate == 2))){editFun(ParticipantsIDs,RelyUnitsIDs);}
				else {Ext.Msg.show({title:'����',msg:'�������ύ���������޸ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}
			}
});

////////////////ɾ����ť//////////////////////////
var delPatentInfoButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ������Ŀ�������',
		iconCls: 'remove',
		handler: function(){
			var rowObj = srmprjitemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len<1){
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫɾ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				for(var i = 0; i < len; i++){
				var state = rowObj[i].get("DataStatuslist");
				var chkstate = rowObj[0].get("ChkResult");  
				//alert(state);			
				if((state == "δ�ύ")||((state == "���ύ")&&(chkstate == 2))){delFun()}
				else {Ext.Msg.show({title:'����',msg:'�������ύ������ɾ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
});

///////////////�ύ��ť//////////////////////////
var subPatentInfoButton = new Ext.Toolbar.Button({
		text:'�ύ',
		tooltip:'�ύѡ������Ŀ�������',
		iconCls:'add',
		handler:function(){
			var rowObj = srmprjitemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len<1){
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�ύ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				for(var i = 0; i < len; i++){
				var state = rowObj[i].get("DataStatuslist");
				//alert(state);		
				if(state == "δ�ύ" ){subFun()}
				else {Ext.Msg.show({title:'����',msg:'�������ύ�������ظ��ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}	
});


////�������밴ť
var SetUpApplyButton = new Ext.Toolbar.Button({
	    text: '��������',  
        iconCls:'option',
        handler:function(){
		//���岢��ʼ���ж���
		var rowObj=srmprjitemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ���������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		
        for(var j= 0; j < len; j++){
         var state = rowObj[j].get("DataStatuslist");
         if (state=="δ�ύ"){
            Ext.Msg.show({title:'����',msg:'��������δ�ύ�����ύ���룡',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
            return;
         }
		 if(rowObj[j].get("ProjStatus")=="����")
		 {
			      Ext.Msg.show({title:'ע��',msg:rowObj[j].get("Name")+'������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }

		}
		//û�и�ѡ�������� ���Բ���forѭ��
		for(var i= 0; i < len; i++){
		   var rowid=rowObj[i].get("rowid");
		   var subno=rowObj[i].get("SubNo");
		   var issuedDate=rowObj[i].get("IssuedDate");
//		   if (issuedDate!=""&&issuedDate!=null){
//				issuedDate=issuedDate.format('Y-m-d');
//			}
		   var grafunds=rowObj[i].get("GraFund");
		   var FundGov =rowObj[i].get("FundGov");
		   var FundOwn=rowObj[i].get("FundOwn");
		   var FundMatched=rowObj[i].get("FundMatched");
		   
		    if(subno==""||subno==null||issuedDate==""||issuedDate==null||grafunds==""||grafunds==null){
				Ext.Msg.show({title:'����',msg:'�����š���׼���ѡ������´�ʱ�������д!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			    return;
		    }
		   // alert(issuedDate+"^"+FundGov+"^"+FundOwn+"^"+FundMatched);
		    if(FundGov==""||FundGov==null||FundOwn==""||FundOwn==null||FundMatched==""||FundMatched==null){
				Ext.Msg.show({title:'����',msg:'�ϼ����ҽԺƥ�䡢��ƥ�������д!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			    return;
			}
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    var rowid=rowObj[i].get("rowid");
						var subno=rowObj[i].get("SubNo");
						var issuedDate=rowObj[i].get("IssuedDate");
					    if (issuedDate!=""&&issuedDate!=null){
							//issuedDate=issuedDate.format('Y-m-d');
						}
						//alert(issuedDate);
						var grafunds=rowObj[i].get("GraFund");
						var FundGov =rowObj[i].get("FundGov");
					    var FundOwn=rowObj[i].get("FundOwn");
					    var FundMatched=rowObj[i].get("FundMatched");
					    Ext.Ajax.request({
						url:projUrl+'?action=setup&rowid='+rowid+'&subno='+subno+'&issuedDate='+issuedDate+'&grafunds='+grafunds+'&FundGov='+FundGov+'&FundOwn='+FundOwn+'&FundMatched='+FundMatched,
						waitMsg:'�ύ��...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){			
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'��������ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});	
								srmprjitemGrid.load({params:{start:0, limit:12}});
								
							}else{
								Ext.Msg.show({title:'����',msg:'��������ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ������?',handler);
    }
});
    //alert("11");
var tbuttonbar = new Ext.Toolbar({   
        items: ['��������:',titleText,'-',findButton,addPatentInfoButton,editPatentInfoButton,delPatentInfoButton,subPatentInfoButton,SetUpApplyButton]   
    });   

var srmprjitemGrid = new dhc.herp.Gridhss({
		    title: '������Ŀ�����',
		    region : 'center',
		    autoScroll:true,
		    url: projUrl,
			  fields : [
			      //new Ext.grid.CheckboxSelectionModel({editable:false}),
			       {
						header : '����ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'Type',
						header : '����',
						width : 80,
						editable:false,
						dataIndex : 'Type'

					},{
						id : 'YearCode',
						header : '���',
						width : 80,
						editable:false,
						dataIndex : 'YearCode'

					},{
						id : 'Dept',
						header : '����',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'Dept'

					},{
						id : 'Name',
						header : '��������',
						editable:false,
						width : 180,
						align: 'left',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
						},
						dataIndex : 'Name'
						
					},	
					{
						id : 'Head',
						header : '��Ŀ������',
						editable:false,
						width : 120,
						hidden:true,
//						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
//						           return '<span style="color:blue;cursor:hand">'+value+'</span>';
//						},
						dataIndex : 'Head'

					},
					{
						id : 'CompleteUnit',
						header : '��Ժ��ɵ�λ',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'CompleteUnit'
					}, {
						id : 'ParticipantsName',
						header : '���������Ա',
						width : 120,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['rowid']
						if (sf != "") {
							return '<span style="color:blue;cursor:hand"><u>���������Ա</u></span>';
						} else {
							return '<span style="color:gray;cursor:hand"></span>';
						}},
						dataIndex : 'ParticipantsName'
					},{
							id:'upload',
							header: '����',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){
						
							return '<span style="color:blue"><u>�ϴ�</u></span>';
						
							}
						
					},{
							id:'download',
							header: '����',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>����</u></span>';
						

					} },{
						id : 'EthicalAuditState',
						header : '��������״̬',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'EthicalAuditState'
					},{
						id : 'DataStatuslist',
						header : '����״̬',
						width : 120,
						editable:false,
						//hidden:true,
						dataIndex : 'DataStatuslist'
					},{
						id : 'ProjStatus',
						header : '��Ŀ״̬',
						width : 120,
						editable:false,
						dataIndex : 'ProjStatus'
					},{
						id : 'ChkResult',
						header : '��˽��',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'ChkResult'
					},{
						id : 'ChkResultlist',
						header : '���д����״̬',
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['ChkResult']
						if (sf == "0") {return '<span style="color:blue;cursor:hand">'+value+'</span>';} 
						if (sf == "1") {return '<span style="color:red;cursor:hand">'+value+'</span>';} 
						if (sf == "2"){return '<span style="color:gray;cursor:hand">'+value+'</span>';}
						},
						width : 120,
						dataIndex : 'ChkResultlist'
					},{
						id : 'Participants',
						header : '����μ���Ա',
						width : 180,
						editable:false,
//						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
//						           return '<span style="color:blue;cursor:hand">'+value+'</span>';
//						},
                        hidden:true,
						dataIndex : 'Participants'

					},{
						id : 'PTName',
						header : '������Դ',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'PTName'

					},{
						id : 'Department',
						header : '�����',
						width : 120,
						editable:false,
						dataIndex : 'Department'

					},{
						id : 'SubNo',
						header : '������',
						width : 120,
						dataIndex : 'SubNo'
//						renderer: function(value, cellmeta, record, rowIndex,
//								columnIndex, store){
//								 if(record.data["ProjStatus"]!='����'){			 
//								 this.editable=false;
//								 //console.log(this.editable+"<-edit"+this.value+"<-value");
//								 return '<span>'+value+'</span>';
//								 }else{
//								 this.editable=true;
//								 return '<span>'+value+'</span>';
//								 }
//								}

					},{
						id : 'GraFund',
						header : '��׼����',
						width : 120,
						align:'right',
						dataIndex : 'GraFund',
                        type:grafundsField              //���ö������ֵ�ı���
//					   renderer: function(value, cellmeta, record, rowIndex,
//								columnIndex, store){
//								 if(record.data["ProjStatus"]!='����'){
//								 this.editable=false;
//								 return '<span>'+value+'</span>';
//								 }else{
//								 this.editable=true;
//								 return '<span>'+value+'</span>';
//								 }
//								}
					},{
						id : 'IssuedDate',
						header : '�����´�ʱ��',
						width : 120,
						//editable:false,
						dataIndex : 'IssuedDate',
						type: "dateField"
						//dateFormat: 'Y-m-d'
//						renderer: function(value, cellmeta, record, rowIndex,
//								columnIndex, store){
//								 if(record.data["ProjStatus"]!='����'){
//								 this.editable=false;
//								 return '<span>'+value+'</span>';
//								 }else{
//								 this.editable=true;
//								 return '<span>'+value+'</span>';
//								 }
//								}

					},
					
				{
						id : 'FundGov',
						header : '�ϼ������Ԫ��',
						width : 120,
						//editable:false,
						align:'right',
						dataIndex : 'FundGov'

					},{
						id : 'FundOwn',
						header : 'ҽԺƥ�䣨��Ԫ��',
						width : 120,
						align:'right',
						//editable:false,
						dataIndex : 'FundOwn'

					},{
						id : 'FundMatched',
						header : '��ƥ�䣨��Ԫ��',
						width :120,
						align:'right',
						//editable:false,
						dataIndex : 'FundMatched'
					},
					{
						id : 'AppFund',
						header : '���뾭�ѣ���Ԫ��',
						width :120,
						align:'right',
						editable:false,
						dataIndex : 'AppFund'
					},{
						id : 'RelyUnit',
						header : '�������е�λ',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'RelyUnit'

					},{
						id : 'PrjCN',
						header : '��ͬ��',
						width : 120,
						hidden:true,
						editable:false,
						dataIndex : 'PrjCN'

                    },{
						id : 'StartDate',
						header : '��ʼ����',
						width :120,
						editable:false,
						dataIndex : 'StartDate',
                        hidden:true
					},{
						id : 'EndDate',
						header : '��������',
						width :120,
						editable:false,
						dataIndex : 'EndDate',
                        hidden:true
					},{
						id : 'SEndDate',
						header : '��ֹ����',
						width :120,
						editable:false,
						hidden:true,
						dataIndex : 'SEndDate'

					},{
						id : 'IsGovBuy',
						header : '�Ƿ�������Ŀ',
						width :120,
						editable:false,
						hidden:true,
						dataIndex : 'IsGovBuy'

					},{
						id : 'IsEthicalApproval',
						header : '�Ƿ���������',
						width :120,
						editable:false,
						hidden:true,
						dataIndex : 'IsEthicalApproval'
					},{
						id : 'SubUser',
						header : '������',
						width : 120,
						editable:false,
						dataIndex : 'SubUser'

					},{
						id : 'SubDate',
						header : '����ʱ��',
						width : 120,
						editable:false,
						dataIndex : 'SubDate'

					},{
						id : 'HeadDr',
						header : '������ID',
						width : 120,
						editable:false,
						hidden: true,
						dataIndex : 'HeadDr'
					},{
						id : 'ParticipantsIDs',
						header : '�μ���ԱID',
						width : 120,
						editable:false,
						hidden: true,
						dataIndex : 'ParticipantsIDs'
					},{
						id : 'RelyUnitIDs',
						header : '�μ���ԱID',
						width : 120,
						editable:false,
						hidden: true,
						dataIndex : 'RelyUnitIDs'
					}],
					split : true,
					collapsible : true,
					containerScroll : true,
					xtype : 'grid',
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.RowSelectionModel({
								singleSelect : true
							}),
					loadMask : true,
					//viewConfig : {forceFit : true},
					tbar :['����:',TypeCombox,'-','��ʼʱ��:', PSField,'-','����ʱ��:',PEField,'-','��������:', deptCombo, '-', '������Դ:',SubSourceCombo,'-','���⸺����:',userCombo],
					
					listeners : { 'render': function(){ 
            tbuttonbar.render(this.tbar); 
             } 
         },
     
					height:230,
					trackMouseOver: true,
					stripeRows: true	
		});

    srmprjitemGrid.btnAddHide();  //�������Ӱ�ť
    srmprjitemGrid.btnSaveHide();  //���ر��水ť
    //srmprjitemGrid.btnResetHide();  //�������ð�ť
    srmprjitemGrid.btnDeleteHide(); //����ɾ����ť
    // srmprjitemGrid.btnPrintHide();  //���ش�ӡ��ť


srmprjitemGrid.load({	params:{start:0, limit:25,userdr:userdr}});

uploadMainFun(srmprjitemGrid,'rowid','P007',9);
downloadMainFun(srmprjitemGrid,'rowid','P007',10);



srmprjitemGrid.on('rowclick',function(grid,rowIndex,e){	
	var rowid= '';
	var selectedRow = srmprjitemGrid.getSelectionModel().getSelections();
	rowid=selectedRow[0].data['rowid'];
        
	//DetailGrid.load({params:{start:0, limit:12,rowid:rowid}});	
	//xm--20160524ɾ����Ŀ��Ŀά��
	//PrjItemInfoGrid.load({params:{start:0,limit:25,PrjDR:rowid}});
});


// ����gird�ĵ�Ԫ���¼�
srmprjitemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	 //alert(columnIndex)
//		if (columnIndex == 3){
//			var records = srmprjitemGrid.getSelectionModel().getSelections();
//			var projectrowid = records[0].get("rowid");
//			CompInfoList(projectrowid);
//			}
//		if (columnIndex == 4) {
//			var records = srmprjitemGrid.getSelectionModel().getSelections();
//			var headdr = records[0].get("HeadDr");
//			HeadInfoList(headdr);
//		}
//		if(columnIndex==5){
//			var records = srmprjitemGrid.getSelectionModel().getSelections();
//			var participantsdrs = records[0].get("ParticipantsIDs");
//			ParticipantsInfoList(participantsdrs);
//		}

		var records = srmprjitemGrid.getSelectionModel().getSelections();
	    if (columnIndex == 5) {
	    
				var ProjectDR   = records[0].get("rowid");
				var RelyUnitsIDs = records[0].get("RelyUnitIDs");
				titleFun(ProjectDR,RelyUnitsIDs);
		}

		if(columnIndex == 8){
		
		var Name = records[0].get("Name");
		var ParticipantsIDs = records[0].get("ParticipantsIDs");
		//alert(ParticipantsIDs);
		ParticipantsInfoFun(Name,ParticipantsIDs);
		}
}

);

if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{
	  //findButton.disable();//����Ϊ������
	  addPatentInfoButton.disable();//����Ϊ������
	  delPatentInfoButton.disable();//����Ϊ������
	  subPatentInfoButton.disable();//����Ϊ������
	  SetUpApplyButton.disable();//����Ϊ������
}
if (groupdesc=="���й���ϵͳ(��Ϣ��ѯ)")
{
	  editPatentInfoButton.disable();//����Ϊ������
	  addPatentInfoButton.disable();//����Ϊ������
	  delPatentInfoButton.disable();//����Ϊ������
	  subPatentInfoButton.disable();//����Ϊ������
	  SetUpApplyButton.disable();//����Ϊ������
}

