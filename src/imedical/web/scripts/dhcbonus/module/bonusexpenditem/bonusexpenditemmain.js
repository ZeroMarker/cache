var mainUrl = '../csp/dhc.bonus.module.bonusexpenditemexe.csp?action=list';
var tmpNode = "";
var addButton = new Ext.Toolbar.Button({
	text: '���',
    tooltip:'���',        
    iconCls:'add',
	handler:function(){
	
		var tmpRowid = "";
		var tmpcode = "";
		var tmpname = "";
		var tmpCalc = "";
		var tmpmonth="";
		var tmprate="";
		var tmpLeaf="";
		var tmpLevel=0;
		var tmpType="";
		
		if (tmpNode!="") {
			tmpRowid =   tmpNode.attributes["Rowid"];
			tmpcode = tmpNode.attributes["code"];
			tmpname =  tmpNode.attributes["name"];
			tmpCalc= tmpNode.attributes["IsCalcName"];
			tmpmonth = tmpNode.attributes["month"];
			tmprate = tmpNode.attributes["rate"];
			tmpLeaf = tmpNode.attributes["leaf"];
			tmpsuperid=tmpNode.attributes["SuperCode"];
			tmpLevel=tmpNode.attributes["ItemLevel"];
			tmpLevel=parseInt(tmpLevel);
			tmpType=tmpNode.attributes["expendtype"];
		}
		if(tmpLevel=="")
		{
			
		     tmpLevel=1;
		 
		}
		else
		{
			tmpLevel=tmpLevel+1;
        }
		if(tmpLeaf){
			Ext.Msg.show({title:'����',msg:'ĩ����������ӽڵ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}else{
			
			var CodeField = new Ext.form.TextField({
				fieldLabel: '��Ŀ����',
				width:180,
				anchor: '95%',
				selectOnFocus:'true'
			});
			
			var NameField = new Ext.form.TextField({
				fieldLabel: '��Ŀ����',
				width:180,
				anchor: '95%',
				selectOnFocus:'true'
			});
		
		
			var CalcField = new Ext.form.Checkbox({												
				fieldLabel: '�Ƿ����',
				value:true
			});
			
								
			
			//1��ƿ�Ŀ
			//2ҽ��ָ��
			var MonthField = new Ext.form.ComboBox({												
				fieldLabel: '��̯�·�',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', 'һ��'], ['2', '����'], ['3', '����'], ['4', '����'], ['5', '����'], ['6', '����'], ['7', '����'], ['8', '����'], ['9', '����'], ['10', 'ʮ��'], ['11', 'ʮһ��'], ['12', 'ʮ����']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '1',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : 'ѡ��...',
				selectOnFocus:'true'
			});
		        var ExpendTypeFeild = new Ext.form.ComboBox({												
				fieldLabel: '֧�����',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '��Ա����'], ['2', '��������'], ['3', '�칫��Ʒ'], ['4', '�۾ɷ�'], ['5', 'ά�޷���'], ['6', '��̯����'], ['9', '�����ɱ�']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : tmpType,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : 'ѡ��...',
				selectOnFocus:'true'
			});
		    var RateField = new Ext.form.TextField({
				fieldLabel: '����ϵ��',
				width:180,
			
				anchor: '95%',
				selectOnFocus:'true'
			});
		
		    var LastField = new Ext.form.Checkbox({												
				fieldLabel: '�Ƿ�ĩ��',
				value:'true'
			});
			////////////////////////////////////////////////////////
		

			var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									CodeField ,				
									NameField,				
									CalcField,				
									MonthField,	
									ExpendTypeFeild	,		
									RateField,									
									CalcField,
									LastField	
								]
							}]
					}
				]			
			
			var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 80,
				//layout: 'form',
				frame: true,
				items: colItems
			});
	
			addButton = new Ext.Toolbar.Button({
				text:'���'
			});

			addHandler = function(){
			
				var Code				= CodeField.getValue();
				var Name				= NameField.getValue();
				var Calc				= CalcField.getValue();	
				var Month				= MonthField.getValue();
				var Rate				= RateField.getValue();
				var Last		        = LastField.getValue();
				var ExpendType          =ExpendTypeFeild.getValue();

			
				if(Last){
					Last = 1;
				}else{
					Last = 0;
				}
				if(Calc){
					Calc = 1;
				}else{
					Calc = 0;
				}
				
				
           
				var data = Code+"|"+Name+"|"+Calc+"|"+Month+"|"+Rate+"|"+tmpRowid+"|"+Last+"|"+tmpLevel+"|"+ExpendType;
							
				if(formPanel.form.isValid()){
					Ext.Ajax.request({
						url: '../csp/dhc.bonus.module.bonusexpenditemexe.csp?action=add&data='+encodeURIComponent(data),
						waitMsg:'������...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
								
								if(tmpNode==""){
								mainGrid.root.reload();
								
								}
								else{
							   var tmp= mainGrid.getSelectionModel().getSelectedNode();
							    mainGrid.loader.load(tmp);
								tmp.expand(false);
							
								//mainGrid.loader.load(tmpNode);
								//tmpNode.expand(false);
								}
								
								tmpNode = "";
								//mainGrid.root.reload();
							}else{
								var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'����',msg:tmpMsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}else{
					Ext.Msg.show({title:'����',msg:'������ҳ���ϵĴ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
			
			addButton.addListener('click',addHandler,false);
	
			cancelButton = new Ext.Toolbar.Button({
				text:'ȡ��'
			});
			
			cancelHandler = function(){
				addwin.close();
			}
			
			cancelButton.addListener('click',cancelHandler,false);
	
			addwin = new Ext.Window({
				title: '��Ӻ�����',
				width: 300,
				height: 300,
				//autoHeight: true,
				atLoad: true,
				layout: 'fit',
				plain:true,
				modal:true,
				bodyStyle:'padding:5px;',
				buttonAlign:'center',
				items: formPanel,
				buttons: [
					addButton,
					cancelButton
				]
			});
		
			addwin.show();
			
		}
	
	}
});

var editButton = new Ext.Toolbar.Button({
	text: '�޸�',
    tooltip:'�޸�',        
    iconCls: 'option',
	handler:function(){

		if(tmpNode==""){
			Ext.Msg.show({title:'����',msg:'û��ѡ��ڵ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}else{
			tmpRowid =   tmpNode.attributes["Rowid"];
			tmpcode = tmpNode.attributes["code"];
			tmpname =  tmpNode.attributes["name"];
			tmpCalc= tmpNode.attributes["IsCalcName"];
			tmpmonth = tmpNode.attributes["month"];
			tmprate = tmpNode.attributes["rate"];
			tmpLeaf = tmpNode.attributes["leaf"];
			tmpType=tmpNode.attributes["expendtype"];
							
			if(tmpCalc=="��"){
				tmpCalc = true
			}else{
				tmpCalc = false
			}				
				
			
			var CodeField = new Ext.form.TextField({
				fieldLabel: '��Ŀ����',
				width:180,
			    value:tmpcode,
				anchor: '95%',
				selectOnFocus:'true'
			});
			
			var NameField = new Ext.form.TextField({
				fieldLabel: '��Ŀ����',
				width:180,
			    value:tmpname,
				anchor: '95%',
				selectOnFocus:'true'
			});
		
		
			var CalcField = new Ext.form.Checkbox({												
				fieldLabel: '�Ƿ����',
				checked:tmpCalc
			});
			
								
			
			//1��ƿ�Ŀ
			//2ҽ��ָ��
			var MonthField = new Ext.form.ComboBox({												
				fieldLabel: '��̯�·�',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', 'һ��'], ['2', '����'], ['3', '����'], ['4', '����'], ['5', '����'], ['6', '����'], ['7', '����'], ['8', '����'], ['9', '����'], ['10', 'ʮ��'], ['11', 'ʮһ��'], ['12', 'ʮ����']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
			    value:tmpmonth,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : 'ѡ��...',
				selectOnFocus:'true'
			});
			var ExpendTypeFeild = new Ext.form.ComboBox({												
				fieldLabel: '֧�����',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '��Ա����'], ['2', '��������'], ['3', '�칫��Ʒ'], ['4', '�۾ɷ�'], ['5', 'ά�޷���'], ['6', '��̯����'], ['9', '�����ɱ�']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : tmpType,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : 'ѡ��...',
				selectOnFocus:'true'
			});
		    var RateField = new Ext.form.TextField({
				fieldLabel: '����ϵͳ',
				width:180,
				value:tmprate,
				anchor: '95%',
				selectOnFocus:'true'
			});
		
		    var LastField = new Ext.form.Checkbox({												
				fieldLabel: '�Ƿ�ĩ��',
				checked:tmpLeaf
			});
						////////////////////////////////////////////////////////
			
			
			var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
	
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									CodeField ,				
									NameField,				
									MonthField,	
									ExpendTypeFeild,			
									RateField,	
									CalcField,
									LastField
								]
							}]
					}
				]			
			
			var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 70,
				//layout: 'form',
				frame: true,
				items: colItems
			});
	
			editButton = new Ext.Toolbar.Button({
				text:'�޸�'
			});

			addHandler = function(){
			   
				var Code				= CodeField.getValue();
				var Name				= NameField.getValue();
				var Calc				= CalcField.getValue();	
				var Month				= MonthField.getValue();
				var Rate				= RateField.getValue();
				var Last		        = LastField.getValue();
				var ExpendType          = ExpendTypeFeild.getValue();
				if(Last){
					Last = 1;
				}else{
					Last = 0;
				}
				if(Calc){
					Calc= 1;
				}else{
					Calc = 0;
				}
	
	
				var data =Code+"|"+Name+"|"+Calc+"|"+Month+"|"+Rate+"|"+Last+"|"+ExpendType;
				if(formPanel.form.isValid()){
					Ext.Ajax.request({
						url: '../csp/dhc.bonus.module.bonusexpenditemexe.csp?action=edit&rowid='+tmpRowid+'&data='+encodeURIComponent(data),
						waitMsg:'������...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
								if(Last==1){
									
									var tmpPar=tmpNode.parentNode;
								
									mainGrid.loader.load(tmpPar);
									tmpPar.expand(false);
								}
								else{	
								mainGrid.root.reload();
								}
								tmpNode = "";
								editwin.close();
							}else{
								var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'����',msg:tmpMsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}else{
					Ext.Msg.show({title:'����',msg:'������ҳ���ϵĴ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
			
			editButton.addListener('click',addHandler,false);
	
			cancelButton = new Ext.Toolbar.Button({
				text:'ȡ��'
			});
			
			cancelHandler = function(){
				editwin.close();
			}
			
			cancelButton.addListener('click',cancelHandler,false);
	
			editwin = new Ext.Window({
				title: '�޸ĺ�����',
				width: 300,
				height: 300,
				//autoHeight: true,
				layout: 'fit',
				plain:true,
				modal:true,
				bodyStyle:'padding:5px;',
				buttonAlign:'center',
				items: formPanel,
				buttons: [
					editButton,
					cancelButton
				]
			});
		
			editwin.show();

		}
	}
});

var delButton = new Ext.Toolbar.Button({
	text: 'ɾ��',
    tooltip:'ɾ��',        
    iconCls:'remove',
	handler:function(){
		var tmpRowid = "";
		var tmpLeaf = "";
		if (tmpNode!="") {
			tmpRowid =   tmpNode.attributes["Rowid"];
			tmpcode = tmpNode.attributes["code"];
			tmpname =  tmpNode.attributes["name"];
			tmpCalc= tmpNode.attributes["IsCalcName"];
			tmpmonth = tmpNode.attributes["month"];
			tmprate = tmpNode.attributes["rate"];
			tmpLeaf = tmpNode.attributes["leaf"];	
			
			function handler(id){
				if(id=="yes"){
					Ext.Ajax.request({
						url:'../csp/dhc.bonus.module.bonusexpenditemexe.csp?action=del&rowid='+tmpRowid+'&code='+tmpcode,
						waitMsg:'ɾ����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								tmpNode.remove();
								tmpNode.expand(false);
							}else{
								Ext.Msg.show({title:'����',msg:'ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}else{
					return;
				}
			}
			
			if(tmpLeaf){
				Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ����?',handler);
			}else{
				Ext.MessageBox.confirm('��ʾ','�����ӽڵ�,ȷʵҪɾ����?',handler);
			}
	
		}else{
			Ext.Msg.show({title:'����',msg:'��ѡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}
	}
});

var checkButton = new Ext.Toolbar.Button({
	text: '���',
    tooltip:'���',        
    iconCls:'remove',
	handler:function(){
		var tmpRowid = "";
		var tmpLeaf = "";
		var userid=session['LOGON.USERNAME'];
		if (tmpNode!="") {
			tmpRowid =   tmpNode.attributes["Rowid"];
			tmpcode = tmpNode.attributes["code"];
			tmpLeaf = tmpNode.attributes["leaf"];	
			
		
			function handler(id){
				if(id=="yes"){
					Ext.Ajax.request({
						url:'../csp/dhc.bonus.module.bonusexpenditemexe.csp?action=check&rowid='+tmpRowid+'&code='+tmpcode+'&user='+userid,
						waitMsg:'ɾ����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								mainGrid.root.reload();
							}else{
								Ext.Msg.show({title:'����',msg:'���ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}else{
					return;
				}
			}
			
			if(tmpLeaf){
				Ext.MessageBox.confirm('��ʾ','ȷʵҪ�����?',handler);
			}else{
				Ext.MessageBox.confirm('��ʾ','�����ӽڵ�,ȷʵҪ�����?',handler);
			}
	
		}else{
			Ext.Msg.show({title:'����',msg:'��ѡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}
	}
});
var mainGrid = new Ext.ux.tree.TreeGrid({
    title: '֧������������',
	region: 'center',
    enableDD: true,

    columns:[{
        header: '֧����Ŀ',
        width: 160,
        dataIndex: 'name'
    },{
        header: '֧����Ŀ����',
        width: 150,
        dataIndex: 'code'
    },{
        header: '��̯�·�',
        width: 60,
        dataIndex: 'month'
    },{
        header: '�Ƿ����',
        width: 60,
        dataIndex: 'IsCalcName'
    },
	//{
   //    header: '���㹫ʽ',
   //    width: 150,
   //    dataIndex: 'Formula'
   //},
   {
        header: '�Ƿ����',
        width: 60,
        dataIndex: 'StateName'
    },
      
	{
        header: '����ϵ��',
        width: 100,
        dataIndex: 'rate'
    },
    
	{
        header: '�ϼ���λ����',
        width: 100,
        dataIndex: 'SuperCode'
    },
	{
        header: '���ʱ��',
        width: 100,
        dataIndex: 'CheckDate'
    },{
        header: '�����',
        width: 100,
        dataIndex: 'CheckMan'
    },{
        header: '����ʱ��',
        width: 100,
        dataIndex: 'updateData'
    },{
        header: '�Ƿ�ĩ���ڵ�',
        width: 100,
        dataIndex: 'leaf'
    },{
        header: '�ڵ�㼶',
        width: 100,
        dataIndex: 'ItemLevelName'
    },{
        header: '֧�����',
        width: 100,
        dataIndex: 'expendtypename'
    }],

    requestUrl: mainUrl,
	
	listeners: {
        'beforeload': function (node) {
       
         
            if (node.isRoot) {
	           
              this.loader.dataUrl = this.requestUrl + "&rnode=";
            }else { 
                var nodeText = node.attributes["Rowid"];
                var rqtUrl = this.requestUrl + "&rnode=" + nodeText;
                if (node.attributes.loader.dataUrl) {
                    this.loader.dataUrl = rqtUrl
                }
            }
          this.root.attributes.loader = null;
        },
		
		'click' : function( node,  e ) {
			tmpNode = node;
		}
    },
	
	tbar:[addButton,'-',editButton,'-',delButton,'-',checkButton]
});