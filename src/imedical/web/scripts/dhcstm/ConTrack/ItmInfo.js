 
//创建编辑窗口(弹出)
//rowid :供应商rowid
var remarkWindow;
var list='';
function CreateEditWin(List,Fn){
	list=List;
	if(remarkWindow){
		remarkWindow.show();
		return;
	}
	
	//厂商代码
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel:'<font color=red>合同号</font>',
		allowBlank:false,
		//width:200,
		listWidth:50,
		anchor:'90%',
		//disabled:true,
		selectOnFocus:true
	});
	//厂商名称
	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel:'<font color=red>备注</font>',
		allowBlank:false,
		//width:200,
		listWidth:50,
		//emptyText:'厂商名称...',
		anchor:'90%',
		//disabled:true,
		selectOnFocus:true
	})	
	var ExcuteExpDate = new Ext.ux.DateField({ 
		id:'ExcuteExpDate',
		fieldLabel:'生效日期',  
		allowBlank:true,
		//width:200,
		listWidth:50,  
		anchor:'90%'
	});  
	var ExpDate = new Ext.ux.DateField({ 
		id:'ExpDate',
		fieldLabel:'合同截止日期',  
		allowBlank:true,
		//width:200,
		listWidth:50,  
		anchor:'90%'
	});
	
	var LcFlagField = new Ext.form.Checkbox({
		id: 'LcFlagField',
		fieldLabel:'临采标志',
		hideLabel:false,
		allowBlank:false
	})
	
	var StopField = new Ext.form.Checkbox({
		id: 'StopField',
		fieldLabel:'停用标志',
		hideLabel:false,
		allowBlank:false
	})
	
	
	var CVendor=new Ext.ux.VendorComboBox({
            id : 'CVendor',
            name : 'CVendor',
            anchor : '90%'
        });
	
	
	

	//初始化添加按钮
	var okButton = new Ext.Toolbar.Button({
		text:'确定',
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
                 Msg.info("warning","合同截止日期不能为空！");
                 return ;
            }
       
      
       var vendid=Ext.getCmp("CVendor").getValue();  
        if((vendid==null)||(vendid=="")){
          Msg.info("warning","供应商不能为空!"); 
          return false;
       }
       var data=contnum+"^"+remark+"^"+StartDate+"^"+EndDate+"^"+gLocId+"^"+gUserId+"^"+vendid+"^"+lcflag+"^"+MStopFlag;
       if((contnum==null)||(contnum=="")){
          Msg.info("warning","没有要保存的数据!"); 
          return false;
       }
       
       if(list==""){
	       saveMethod="SaveContNo"
       }else{
	       saveMethod="UpdateContData"
       }
        var url = "dhcstm.contrackaction.csp?actiontype="+saveMethod
         var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
         Ext.Ajax.request({
            url : url,
            method : 'POST',
            params:{ContNoData:data},
            waitMsg : '处理中...',
            success : function(result, request) {
                var jsonData = Ext.util.JSON
                        .decode(result.responseText);
                if (jsonData.success=='true') {
                    Msg.info("success", "保存成功!");
                    loadMask.hide();
                    remarkWindow.close();
                    Fn(contnum);
          
                }else{ 
                        var ret=jsonData.info;
                        if(ret==-3){
                            Msg.info("error", "合同号重复!");
                            loadMask.hide();
                            return false;
                        }else{
                            Msg.info("error", "保存失败!");
                            loadMask.hide();
                            return false;
                        }
                        
                }
            },
            scope : this
        });
		}
	});
	
	//初始化取消按钮
	var cancelButton = new Ext.Toolbar.Button({
		text:'取消',
		handler:function(){
			//alert(Ext.getCmp('codeField').getValue());
			if (remarkWindow){
				remarkWindow.close();
			}
		}
	});
	
	//初始化面板
	var vendorPanel = new Ext.form.FormPanel({
		labelwidth : 30,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5px;',
		items : [{
			xtype : 'fieldset',
			title : '基本信息',
			autoHeight : true,
			items : [
			    codeField,nameField,CVendor,ExcuteExpDate,ExpDate,LcFlagField,StopField
			]
		}]
	});
	
	
	//初始化窗口
	remarkWindow = new Ext.Window({
		
		title:'合同信息',
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

	//显示供应商信息
	function SetVendorInfo(list){
		Ext.Ajax.request({
			url: 'dhcstm.contrackaction.csp?actiontype=Select&rowid='+list,
			failure: function(result, request) {
				Msg.info("error",'失败！');
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					var value = jsonData.info;
					var arr = value.split("^");
					//基础信息
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