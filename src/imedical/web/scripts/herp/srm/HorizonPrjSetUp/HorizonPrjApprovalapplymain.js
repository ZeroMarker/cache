var projUrl = 'herp.srm.horizonprjsetupexe.csp';

var userdr = session['LOGON.USERCODE'];

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
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

 ///��Ŀ��Դ
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
			fieldLabel : '��Ŀ��Դ',
			store : SubSourceDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

///////////////////��Ŀ״̬
var PrjStateStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '����'], ['2', 'ִ��'],['3','����'],['4','ȡ��']]
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
			//editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

//////��Ŀ������
var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList&str='+encodeURIComponent(Ext.getCmp('userCombo').getRawValue()),
						method : 'POST'
					});
		});

var userCombo = new Ext.form.ComboBox({
	        id:'userCombo',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			name:'userCombo',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			editable:true,
			allowblank:true
		});
		
// ////////////��Ŀ����
var titleText = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
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
		
		
// ������Ŀ����ʱ��ؼ�
	var IssueDateField = new Ext.form.DateField({
		id : 'IssueDateField',
		//format : 'Y-m-d',
		width : 120,
		//allowBlank : false,
		emptyText : ''
	});
	
// ////////////��Ŀ���
var PrjSubNoText = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});	

//��׼����
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
/*
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	//tooltip: '��ѯ',
	iconCls: 'search',
	handler: function()
	*/
function SearchFun(){
	    
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
	
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,   
		    ApplyStart: startdate,
		    Applyend: enddate,
		    deptdr: dept,
		    SubSource: SubSource,
		    HeadDr: HeadDr,
		    PName: PName,
		    ResAudit:ResAudit,
		    userdr:userdr,
			Type:Type
		   }
	  })
  }
 
 
//});

///////////////////��Ӱ�ť///////////////////////
var addPatentInfoButton = new Ext.Toolbar.Button({
		text: '����',
    	//tooltip: '����µ���Ŀ�������',        
    	iconCls: 'edit_add',
		handler: function(){
			addFun();}
});
/////////////////�޸İ�ť/////////////////////////
var editPatentInfoButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		//tooltip: '�޸�ѡ������Ŀ�������',
		iconCls: 'pencil',
		handler: function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				var state = rowObj[0].get("DataStatuslist");
				var chkstate = rowObj[0].get("ChkResult");  	
				var prjstatusid = rowObj[0].get("ProjStatusID");  	
				var ParticipantsIDs = rowObj[0].get("ParticipantsIDs");
				var RelyUnitsIDs = rowObj[0].get("RelyUnitIDs");
				//alert(state);			
				//if((state == "δ�ύ")||(groupdesc=="���й���ϵͳ(��Ϣ�޸�)" )||((state == "���ύ")&&(chkstate == 2))){editFun(ParticipantsIDs,RelyUnitsIDs);}
				if((state == "δ�ύ")||(groupdesc=="���й���ϵͳ(��Ϣ�޸�)" )||((state == "���ύ")&&(prjstatusid == 4))){editFun(ParticipantsIDs,RelyUnitsIDs);}
				else {Ext.Msg.show({title:'����',msg:'�������ύ���������޸ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}
			}
});

////////////////ɾ����ť//////////////////////////
var delPatentInfoButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		//tooltip: 'ɾ��ѡ������Ŀ�������',
		iconCls: 'edit_remove',
		handler: function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len<1){
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫɾ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				for(var i = 0; i < len; i++){
				var state = rowObj[i].get("DataStatuslist");
				var chkstate = rowObj[0].get("ChkResult");  
				var prjstatusid = rowObj[0].get("ProjStatusID");  	
				//alert(state);			
				//if((state == "δ�ύ")||((state == "���ύ")&&(chkstate == 2))){delFun()}
				if((state == "δ�ύ")||((state == "���ύ")&&(prjstatusid == 4))){delFun()}
				else {Ext.Msg.show({title:'����',msg:'�������ύ������ɾ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
});

///////////////�ύ��ť//////////////////////////
var subPatentInfoButton = new Ext.Toolbar.Button({
		text:'�ύ',
		//tooltip:'�ύѡ������Ŀ�������',
		iconCls: 'pencil',
		handler:function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len<1){
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�ύ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				for(var i = 0; i < len; i++){
				var state = rowObj[i].get("DataStatuslist");
				if(state == "δ�ύ" ){subFun();}
				else {Ext.Msg.show({title:'����',msg:'�������ύ�������ظ��ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}	
});

////�������밴ť
var SetUpApplyButton = new Ext.Toolbar.Button({
	    text: '��������',  
        iconCls: 'pencil',
        handler:function(){
    
		//���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//alert(len);
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ���������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
				for(var i = 0; i < len; i++){
				var state = rowObj[i].get("DataStatuslist");
		        if (state=="δ�ύ"){
		            Ext.Msg.show({title:'����',msg:'��������δ�ύ�����ύ���룡',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		            return;
		        }
				var state = rowObj[i].get("ProjStatus");
				if(state== "����" ){Ext.Msg.show({title:'����',msg:'�������������룬�����ظ��ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				}
				else {
		
                Ext.Ajax.request({
				url:'herp.srm.projectapprovalapplyexe.csp'+'?action=list&prjrowid='+rowObj[0].get("rowid"),
				waitMsg:'�ύ��...',
				failure: function(result, request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){			
					var jsonData = Ext.util.JSON.decode( result.responseText );
					{
	            		//û�и�ѡ�������� ���Բ���forѭ��
						for(var i= 0; i < len; i++){
							var rowid=rowObj[i].get("rowid");
							var subno=rowObj[i].get("SubNo");
							var issuedDate=rowObj[i].get("IssuedDate");
//						    if (issuedDate!=""&&issuedDate!=null){
//							   issuedDate=issuedDate.format('Y-m-d');
//						    }
                            //alert(issuedDate);
							var grafunds=rowObj[i].get("GraFund");
							var FundOwn=rowObj[i].get("FundOwn");
			                var FundMatched=rowObj[i].get("FundMatched");
						    if(subno==""||subno==null||issuedDate==""||issuedDate==null||grafunds==""||grafunds==null){
								Ext.Msg.show({title:'����',msg:'��Ŀ��š���׼���ѡ������´�ʱ�������д!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							    return;
						    }
						    
						}

				}
				
				function handler(id){
			    if(id=="yes"){
				for(var i = 0; i < len; i++){
					    var rowid=rowObj[i].get("rowid");
						var subno=rowObj[i].get("SubNo");
						var issuedDate=rowObj[i].get("IssuedDate");
						
						//�ж��ֶ�company�Ƿ��ѱ��޸�
						if(rowObj[i].isModified('IssuedDate')){
							//alert("xiugaile");
							issuedDate=issuedDate.format('Y-m-d');
							//�������
						}else{
							issuedDate="";
						}

					    /* if (issuedDate!=""&&issuedDate!=null){
							issuedDate=issuedDate.format('Y-m-d');
						} */
						var grafunds=rowObj[i].get("GraFund");
					    var FundOwn=rowObj[i].get("FundOwn");
					    var FundMatched=rowObj[i].get("FundMatched");
					    Ext.Ajax.request({
						url:projUrl+'?action=setup&rowid='+rowid+'&subno='+encodeURIComponent(subno)+'&issuedDate='+issuedDate+'&grafunds='+grafunds+'&FundOwn='+FundOwn+'&FundMatched='+FundMatched,
						waitMsg:'�ύ��...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){			
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'��������ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});	
								itemGrid.load({params:{start:0, limit:12}});
								
							}else{
								Ext.Msg.show({title:'����',msg:'��Ŀ����ظ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
	   }}
       }
		
    } 
});
/*
var tbuttonbar = new Ext.Toolbar({   
        items: [findButton,addPatentInfoButton,editPatentInfoButton,delPatentInfoButton,subPatentInfoButton,SetUpApplyButton]   
    });   
*/
var tbar2=new Ext.Toolbar
(
	{   
		//labelAlign: "right",
		//labelWidth: 370, 
		items:['','��Ŀ��Դ','',SubSourceCombo,'','��Ŀ����','',titleText,'','��Ŀ������','',userCombo]
	}
); 

var queryPanel = new Ext.FormPanel
({
	autoHeight : true,
	region : 'north',
	frame : true,
	//title : '��Ŀ����������Ϣ��ѯ',
	//iconCls : 'search',	
	defaults : 
	{
		bodyStyle : 'padding:5px'
	},
	
	items : 
	[
		{
			columnWidth : 1,
			xtype : 'panel',
			layout : "column",
			items : 
			[
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">��ʼʱ��</p>',
					width : 60			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				PSField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">����ʱ��</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				PEField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">��������</p>',
					width : 70			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				deptCombo,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">����</p>',
					width : 40			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				TypeCombox,
				{
					xtype : 'displayfield',
					value : '',
					width : 30
				},		
				{
					xtype : 'button',
					text : '��ѯ',
					handler : function(b){SearchFun();},
					iconCls : 'search',
					width : 30
				}
			]
		}, 
		{
			columnWidth : 1,
			xtype : 'panel',
			layout : "column",
			items : 
			[
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">��Ŀ��Դ</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},	
				SubSourceCombo,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">��Ŀ����</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				titleText,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">��Ŀ������</p>',
					width : 70			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				userCombo
			]
		}	
	]	

});

var itemGrid = new dhc.herp.Gridhss({
		    //title: '��Ŀ����������Ϣά��',
			//iconCls: 'list',
		    region : 'center',
		    //viewConfig : {forceFit : false},
		    //autoScroll:true,
		    url: projUrl,
			  fields : [
			      //new Ext.grid.CheckboxSelectionModel({editable:false}),
			       {
						header : '��ĿID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'Type',
						header : '����',
						width : 40,
						editable:false,
						dataIndex : 'Type'

					},{
						id : 'YearCode',
						header : '���',
						width : 60,
						editable:false,
						dataIndex : 'YearCode'

					},{
						id : 'Dept',
						header : '����',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'Dept'

					},{
						id : 'Name',
						header : '��Ŀ����',
						editable:false,
						width : 180,
						align: 'left',
						/*
  					    renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
						},
						*/
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return '<span style="color:blue;cursor:hand"><u>'+data+'</u></span>';;
						},
						dataIndex : 'Name'
					},{
						id : 'SubNo',
						header : '��Ŀ���',
						width : 100,
						//editable:true,
						dataIndex : 'SubNo',
						type:PrjSubNoText
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
						header : '��׼����(��Ԫ)',
						width : 100,
						editable:true,
						dataIndex : 'GraFund',
						align:'right',
                        //type:grafundsField,
                        renderer: function(val)
						{
							val=val.replace(/(^\s*)|(\s*$)/g, "");
							val=Ext.util.Format.number(val,'0.00');
							val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
							return val?val:'';
						}                      
					},{
						id : 'IssuedDate',
						header : '��Ŀ����ʱ��',
						width : 80,
						editable:true,
						dataIndex : 'IssuedDate',
						//type: "dateField",
						//dateFormat: 'Y-m-d',
						renderer : function(v, p, r, i) {			
							if (v instanceof Date) {
								return new Date(v).format("Y-m-d");
							} else {return v;}
			            },
						type:IssueDateField
						/* renderer: function(value, cellmeta, record, rowIndex,
								columnIndex, store){
								 if(record.data["ProjStatus"]!='����'){
								 this.editable=false;
								 return '<span>'+value+'</span>';
								 }else{
								 this.editable=true;
								 return '<span>'+value+'</span>';
								 }
								} */
					},{
						id : 'Head',
						header : '��Ŀ������',
						editable:false,
						width : 80,
						hidden : false,
						align: 'left',
  					    renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
						},
						dataIndex : 'Head'

					},{
						id : 'PrjLife',
						header : '��Ŀ����',
						editable:false,
						width : 80,
						align:'right',
						hidden : false,
						dataIndex : 'PrjLife'

					}, {
						id : 'CompleteUnit',
						header : '��Ժ��λλ��',
						editable:false,
						width : 120,
						hidden : true,
						dataIndex : 'CompleteUnit'
					}, {
						id : 'ParticipantsName',
						header : '��Ŀ������Ա',
						width : 80,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['rowid']
						if (sf != "") {
							return '<span style="color:blue;cursor:hand"><u>��Ŀ������Ա</u></span>';
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
						id : 'Participants',
						header : '��Ŀ�μ���Ա',
						width : 180,
						editable:false,
						hidden:true,
						dataIndex : 'Participants'

					},{
						id : 'PTName',
						header : '��Ŀ��Դ',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'PTName'

					},{
						id : 'Department',
						header : '�����',
						width : 180,
						editable:false,
						dataIndex : 'Department',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id : 'FundOwn',
						header : 'ҽԺƥ�䣨��Ԫ��',
						width : 120,
						//editable:false,
						hidden : true,
						align:'right',
						dataIndex : 'FundOwn',
						renderer: function(val) 
						{
       						return Ext.util.Format.number(val,'0.00');
    					}

					},{
						id : 'FundMatched',
						header : '��λ���ѣ���Ԫ��',
						align:'right',
						width :120,
						editable:false,
						dataIndex : 'FundMatched',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},
					{
						id : 'RelyUnit',
						header : '��Ŀ���е�λ',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'RelyUnit'

					},{
						id : 'PrjCN',
						header : '��ͬ��',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'PrjCN'

					},{
						id : 'StartDate',
						header : '��ʼ����',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'StartDate',
                        hidden:true
					},{
						id : 'EndDate',
						header : '��������',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'EndDate',
                        hidden:true
					},{
						id : 'SEndDate',
						header : '��ֹ����',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'SEndDate'

					},{
						id : 'IsGovBuy',
						header : '�Ƿ�������Ŀ',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'IsGovBuy'

					},{
						id : 'AppFund',
						header : '���뾭�ѣ���Ԫ��',
						width :120,
						editable:false,
						align:'right',
						dataIndex : 'AppFund',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},{
						id : 'MonographNum',
						header : '����ר��',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'MonographNum'
					},{
						id : 'PaperNum',
						header : '��������',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'PaperNum'
					},{
						id : 'PatentNum',
						header : 'ר��',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'PatentNum'
					},{
						id : 'InvInCustomStanNum',
						header : '�����ƶ�������׼',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'InvInCustomStanNum'
					},{
						id : 'TrainNum',
						header : '�����˲�',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'TrainNum'
					},{
						id : 'HoldTrainNum',
						header : '�ٰ���ѵ��',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'HoldTrainNum'
					},{
						id : 'InTrainingNum',
						header : '������ѵ��',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'InTrainingNum'
					},{
						id : 'IsEthicalApproval',
						header : '�Ƿ���������',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'IsEthicalApproval'
					},{
						id : 'SubUser',
						header : '��Ŀ������',
						width : 80,
						editable:false,
						dataIndex : 'SubUser'

					},{
						id : 'SubDate',
						header : '��Ŀ����ʱ��',
						width : 80,
						editable:false,
						dataIndex : 'SubDate'

					},{
						id : 'HeadDr',
						header : '������ID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'HeadDr'
					},{
						id : 'ParticipantsIDs',
						header : '�μ���ԱID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'ParticipantsIDs'
					},{
						id : 'RelyUnitIDs',
						header : '�μ���ԱID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'RelyUnitIDs'
					},{
						id : 'EthicalAuditState',
						header : '��������״̬',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'EthicalAuditState'
					},{
						id : 'DataStatuslist',
						header : '����״̬',
						width : 60,
						editable:false,
						//hidden:true,
						dataIndex : 'DataStatuslist'
					},{
						id : 'ProjStatus',
						header : '��Ŀ״̬',
						width : 60,
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
						width : 100,
						dataIndex : 'ChkResultlist'
					},{
						id : 'AlertPercent',
						header : '������',
						editable:false,
						hidden:true,
						width : 100,
						dataIndex : 'AlertPercent'
					},{
						id : 'Remark',
						header : '��ע',
						editable:false,  //ProjStatusID
						hidden:true,
						width : 100,
						dataIndex : 'Remark'
					},{
						id : 'ProjStatusID',
						header : '��Ŀ״̬ID',
						editable:false,  //
						hidden:true,
						width : 100,
						dataIndex : 'ProjStatusID'
					}],
					//split : true,
					//collapsible : true,
					containerScroll : true,
					xtype : 'grid',
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.RowSelectionModel({
								singleSelect : true
							}),
					loadMask : true,
					//viewConfig : {forceFit : true},
					
					tbar :[addPatentInfoButton,editPatentInfoButton,delPatentInfoButton,subPatentInfoButton,SetUpApplyButton],
					/*
					listeners : {   
           'render' : function()
           {   
            	tbar2.render(this.tbar);
            	tbuttonbar.render(this.tbar); 
           }}, */
					/*
					listeners : { 'render': function(){
						
            tbuttonbar.render(this.tbar); 
             } 
         },*/
     
					//height:230,
					trackMouseOver: true,
					stripeRows: true	
		});

    itemGrid.btnAddHide();  //�������Ӱ�ť
    itemGrid.btnSaveHide();  //���ر��水ť
    //itemGrid.btnResetHide();  //�������ð�ť
    itemGrid.btnDeleteHide(); //����ɾ����ť
    // itemGrid.btnPrintHide();  //���ش�ӡ��ť
    
    //������Ŀ�о����ҳ�����Ӻͱ��水ť
     DetailGrid.btnAddHide();
	 DetailGrid.btnSaveHide();


itemGrid.load({	params:{start:0, limit:25,userdr:userdr}});

uploadMainFun(itemGrid,'rowid','P007',13);
    downloadMainFun(itemGrid,'rowid','P007',14);


itemGrid.on('rowclick',function(grid,rowIndex,e){	
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	var rowid=selectedRow[0].data['rowid'];
    var participantsdrs = selectedRow[0].get("ParticipantsIDs");
    var header = selectedRow[0].get("HeadDr");
    //var allparticipants = header+','+participantsdrs;
    var participantsdrarray=participantsdrs.split(",",-1);
    var length=participantsdrarray.length;
    var allparticipants="";
    var allparticipantsarray=participantsdrarray[0].split("-",-1);
    allparticipants=allparticipantsarray[0];
    for(var i=1;i<length;i++)
    {
    	var temparray=participantsdrarray[i].split("-",-1);
    	allparticipants=allparticipants+","+temparray[0];
    }
	DetailGrid.load({params:{start:0, limit:25,rowid:rowid}});	
	ParticipantsInfoGrid.load({params:{start:0,limit:25,participantsdrs:participantsdrs}});
	//xm--20160524ɾ����Ŀ��Ŀά��
	//PrjItemInfoGrid.load({params:{start:0,limit:25,PrjDR:rowid}});
	ProjCompGrid.load({params:{start:0,limit:25,prjrowid:rowid}});
});

//itemGrid.btnAddHide();  //�������Ӱ�ť
//itemGrid.btnSaveHide();  //���ر��水ť
//itemGrid.btnResetHide();  //�������ð�ť
//itemGrid.btnDeleteHide(); //����ɾ����ť
// itemGrid.btnPrintHide();  //���ش�ӡ��ť
   

// ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	 //alert(columnIndex)
//		if (columnIndex == 3){
//			var records = itemGrid.getSelectionModel().getSelections();
//			var projectrowid = records[0].get("rowid");
//			CompInfoList(projectrowid);
//			}
//		if (columnIndex == 4) {
//			var records = itemGrid.getSelectionModel().getSelections();
//			var headdr = records[0].get("HeadDr");
//			HeadInfoList(headdr);
//		}
//		if(columnIndex==5){
//			var records = itemGrid.getSelectionModel().getSelections();
//			var participantsdrs = records[0].get("ParticipantsIDs");
//			ParticipantsInfoList(participantsdrs);
//		}
		var records = itemGrid.getSelectionModel().getSelections();
	    if (columnIndex == 5) {
   
		var ProjectDR   = records[0].get("rowid");
		var RelyUnitsIDs = records[0].get("RelyUnitIDs");
		titleFun(ProjectDR,RelyUnitsIDs);
        }
        if (columnIndex == 9) {
		var Name = records[0].get("Name");
		var HeadDR   = records[0].get("HeadDr");
		//alert(HeadDR);
		responsepeopleInfoFun(Name,HeadDR);
        }
		if(columnIndex == 12){
		var Name = records[0].get("Name");
		var ParticipantsIDs = records[0].get("ParticipantsIDs");
		//alert(ParticipantsIDs);
		ParticipantsInfoFun(Name,ParticipantsIDs);
		}
	
});


if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{
	  //findButton.disable();//����Ϊ������
	  addPatentInfoButton.disable();//����Ϊ������
	  delPatentInfoButton.disable();//����Ϊ������
	  subPatentInfoButton.disable();//����Ϊ������
	  SetUpApplyButton.disable();//����Ϊ������
}

if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{
	  //findButton.disable();//����Ϊ������
	  addPatentInfoButton.disable();//����Ϊ������
	  editPatentInfoButton.disable();//����Ϊ������
	  delPatentInfoButton.disable();//����Ϊ������
	  subPatentInfoButton.disable();//����Ϊ������
	  SetUpApplyButton.disable();//����Ϊ������
}

