 
//�����༭����(����)
//rowid :��Ӧ��rowid
var remarkWindow;
var list='';
function CreateEditWin(List,Fn){
	list=List;
	if(remarkWindow){
		remarkWindow.show();
		return;
	}
	
	//���̴���
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel:'<font color=red>��ͬ��</font>',
		allowBlank:false,
		//width:200,
		listWidth:50,
		anchor:'90%',
		//disabled:true,
		selectOnFocus:true
	});
	//��������
	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel:'<font color=red>��ע</font>',
		allowBlank:false,
		//width:200,
		listWidth:50,
		//emptyText:'��������...',
		anchor:'90%',
		//disabled:true,
		selectOnFocus:true
	})	
	var ExcuteExpDate = new Ext.ux.DateField({ 
		id:'ExcuteExpDate',
		fieldLabel:'��Ч����',  
		allowBlank:true,
		//width:200,
		listWidth:50,  
		anchor:'90%'
	});  
	var ExpDate = new Ext.ux.DateField({ 
		id:'ExpDate',
		fieldLabel:'��ͬ��ֹ����',  
		allowBlank:true,
		//width:200,
		listWidth:50,  
		anchor:'90%'
	});
	
	var LcFlagField = new Ext.form.Checkbox({
		id: 'LcFlagField',
		fieldLabel:'�ٲɱ�־',
		hideLabel:false,
		allowBlank:false
	})
	
	var StopField = new Ext.form.Checkbox({
		id: 'StopField',
		fieldLabel:'ͣ�ñ�־',
		hideLabel:false,
		allowBlank:false
	})
	
	
	var CVendor=new Ext.ux.VendorComboBox({
            id : 'CVendor',
            name : 'CVendor',
            anchor : '90%'
        });
	
	
	

	//��ʼ����Ӱ�ť
	var okButton = new Ext.Toolbar.Button({
		text:'ȷ��',
		handler:function(){	
		  	var contnum=Ext.getCmp("codeField").getValue();
            var remark=Ext.getCmp("nameField").getValue();
            var lcflag=(Ext.getCmp("LcFlagField").getValue()==true)?'Y':'N';
            var MStopFlag=(Ext.getCmp("StopField").getValue()==true)?'Y':'N';
            var StartDate=""
            var EndDate=""
            var RegData=""
            if(Ext.getCmp("ExcuteExpDate").getValue()!=""){
                var StartDate = Ext.getCmp("ExcuteExpDate").getValue().format(ARG_DATEFORMAT).toString();
            }
            if(Ext.getCmp("ExpDate").getValue()!=""){
                 var EndDate = Ext.getCmp("ExpDate").getValue().format(ARG_DATEFORMAT).toString();
            }else{
                 Msg.info("warning","��ͬ��ֹ���ڲ���Ϊ�գ�");
                 return ;
            }
       
      
       var vendid=Ext.getCmp("CVendor").getValue();  
        if((vendid==null)||(vendid=="")){
          Msg.info("warning","��Ӧ�̲���Ϊ��!"); 
          return false;
       }
       var data=contnum+"^"+remark+"^"+StartDate+"^"+EndDate+"^"+gLocId+"^"+gUserId+"^"+vendid+"^"+lcflag+"^"+MStopFlag;
       if((contnum==null)||(contnum=="")){
          Msg.info("warning","û��Ҫ���������!"); 
          return false;
       }
       
       if(list==""){
	       saveMethod="SaveContNo"
       }else{
	       saveMethod="UpdateContData"
       }
        var url = "dhcstm.contrackaction.csp?actiontype="+saveMethod
         var loadMask=ShowLoadMask(Ext.getBody(),"������...");
         Ext.Ajax.request({
            url : url,
            method : 'POST',
            params:{ContNoData:data},
            waitMsg : '������...',
            success : function(result, request) {
                var jsonData = Ext.util.JSON
                        .decode(result.responseText);
                if (jsonData.success=='true') {
                    Msg.info("success", "����ɹ�!");
                    loadMask.hide();
                    remarkWindow.close();
                    Fn(contnum);
          
                }else{ 
                        var ret=jsonData.info;
                        if(ret==-3){
                            Msg.info("error", "��ͬ���ظ�!");
                            loadMask.hide();
                            return false;
                        }else{
                            Msg.info("error", "����ʧ��!");
                            loadMask.hide();
                            return false;
                        }
                        
                }
            },
            scope : this
        });
		}
	});
	
	//��ʼ��ȡ����ť
	var cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��',
		handler:function(){
			//alert(Ext.getCmp('codeField').getValue());
			if (remarkWindow){
				remarkWindow.close();
			}
		}
	});
	
	//��ʼ�����
	var vendorPanel = new Ext.form.FormPanel({
		labelwidth : 30,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5px;',
		items : [{
			xtype : 'fieldset',
			title : '������Ϣ',
			autoHeight : true,
			items : [
			    codeField,nameField,CVendor,ExcuteExpDate,ExpDate,LcFlagField,StopField
			]
		}]
	});
	
	
	//��ʼ������
	remarkWindow = new Ext.Window({
		
		title:'��ͬ��Ϣ',
		width:400,
		height:400,
		minWidth:900,
		minHeight:500,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'right',
		items:vendorPanel,
		buttons:[okButton, cancelButton],
		listeners:{
			'show':function(){
				if (list!=''){
					
					SetVendorInfo(list);
				}
			},
			'close' : function(p){
				remarkWindow=null;
			}
		}
	});
	remarkWindow.show();

	//��ʾ��Ӧ����Ϣ
	function SetVendorInfo(list){
		Ext.Ajax.request({
			url: 'dhcstm.contrackaction.csp?actiontype=Select&rowid='+list,
			failure: function(result, request) {
				Msg.info("error",'ʧ�ܣ�');
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					var value = jsonData.info;
					var arr = value.split("^");
					//������Ϣ
					codeField.setDisabled("true");
					Ext.getCmp('codeField').setValue(arr[0]);
					Ext.getCmp('nameField').setValue(arr[1]);
					Ext.getCmp('ExcuteExpDate').setValue(arr[2]);
					Ext.getCmp('ExpDate').setValue(arr[3]);
				
					addComboData(Ext.getCmp("CVendor").getStore(),arr[4],arr[5]);
                    Ext.getCmp("CVendor").setValue(arr[4]);
                    Ext.getCmp("LcFlagField").setValue(arr[6]=='Y'?true:false)
                    Ext.getCmp("StopField").setValue(arr[7]=='Y'?true:false)
				}
			},
			scope: this
		});
	}
	
	
}	