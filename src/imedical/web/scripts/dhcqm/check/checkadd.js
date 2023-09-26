/**检查点维护添加功能弹出框
* cyl 2016-05-04
**/


//重写组件中的add方法 2016-05-04 cyl add
dhc.herp.Grid.prototype.add=function(){
    //==================定义form表单==START======================//

var uCodeField = new Ext.form.TextField({
        id: 'uCodeField',
        fieldLabel: '检查点编码',
        width:325,
        allowBlank:false,
        triggerAction: 'all',
        emptyText:'请填写检查点编码',
        minChars: 1,
        editable:true
    });
var uNameField = new Ext.form.TextField({
    id:'uNameField',
    fieldLabel: '检查点名称',
    width:325,
    allowBlank:false,
    triggerAction:'all',
    emptyText:'请填写检查点名称',
    minChars:1,
    editable:true
    
});
var uDescField = new Ext.form.TextArea({
    id:'uDescField',
    fieldLabel: '检查点描述',
    width:325,
    allowBlank:false,
    triggerAction:'all',
    //emptyText:'请填写检查点名称',
    //minChars:1,
    editable:true
    
});
var colTypeRadio= new Ext.form.RadioGroup({
    name:'colTypeRadio',
    fieldLabel:'收集方式',
    columns:4,
    items:[{
        boxLabel:'录入',
        inputValue:'1',
        name:'colTypeRadio',
        style:'height:14px'
    },{
        boxLabel:'采集',
        inputValue:'2',
        name:'colTypeRadio',
        style:'height:14px'
    },{
        boxLabel:'计算',
        inputValue:'3',
        name:'colTypeRadio',
        style:'height:14px'
    },{
        boxLabel:'Excel导入',
        inputValue:'1',
        name:'colTypeRadio',
        style:'height:14px',
        checked:true
    }]
});
var locTypeRadio= new Ext.form.RadioGroup({
    name:'locTypeRadio',
    fieldLabel:'检查类型',
    columns:4,
    items:[{
        boxLabel:'扣选择科室',
        inputValue:'1',
        name:'locTypeRadio',
        style:'height:14px',
        checked:true
    },{
        boxLabel:'扣列表科室',
        inputValue:'2',
        name:'locTypeRadio',
        style:'height:14px'
    }]
});
var assessTypeRadio= new Ext.form.RadioGroup({
    name:'assessTypeRadio',
    fieldLabel:'考核类型',
    columns:4,
    items:[{
        boxLabel:'选项',
        inputValue:'1',
        name:'assessTypeRadio',
        style:'height:14px',
        checked:true
    },{
        boxLabel:'文本',
        inputValue:'2',
        name:'assessTypeRadio',
        style:'height:14px'
    }]
});
var photoRadio= new Ext.form.RadioGroup({
    name:'photoRadio',
    fieldLabel:'是否拍照',
    columns:4,
    items:[{
        boxLabel:'是',
        inputValue:'Y',
        name:'photoRadio',
        style:'height:14px',
        checked:true
    },{
        boxLabel:'否',
        inputValue:'N',
        name:'photoRadio',
        style:'height:14px'
    }]
});
var spcilRadio= new Ext.form.RadioGroup({
    name:'spcilRadio',
    fieldLabel:'特殊指示',
    columns:4,
    items:[{
        boxLabel:'是',
        inputValue:'Y',
        name:'spcilRadio',
        style:'height:14px',
        checked:true
    },{
        boxLabel:'否',
        inputValue:'N',
        name:'spcilRadio',
        style:'height:14px'
    }]
});
var objTypeRadio= new Ext.form.RadioGroup({
    name:'objTypeRadio',
    fieldLabel:'检查对象类型',
    columns:4,
    items:[{
        boxLabel:'科室',
        inputValue:'1',
        name:'objTypeRadio',
        style:'height:14px'
        
    },{
        boxLabel:'病人',
        inputValue:'2',
        name:'objTypeRadio',
        style:'height:14px',
        checked:true
    }]
});
var activeRadio=new Ext.form.RadioGroup({
        name:'activeRadio',
        fieldLabel:'是否有效',
        columns: 4,
        items:[{
            boxLabel:'是',
            inputValue:'Y',
            name:'activeRadio',
            style:'height:14px;',
            checked:true
        },{
            boxLabel:'否',
            inputValue:'N',
            style:'height:14px;',
            name:'activeRadio'
        }]
    });
var compRadio=new Ext.form.RadioGroup({
        name:'compRadio',
        fieldLabel:'参与考核',
        columns: 4,
        items:[{
            boxLabel:'是',
            inputValue:'Y',
            name:'compRadio',
            style:'height:14px;',
            checked:true
        },{
            boxLabel:'否',
            inputValue:'N',
            style:'height:14px;',
            name:'compRadio'
        }]
    });

//保存按钮
    var usaveBtn = new Ext.Button({
        text:'保存',
        //iconCls:'save',
        handler:function(){
            
            //获取值
            var uCodeField = Ext.getCmp('uCodeField').getValue();
            var uNameField = encodeURIComponent(Ext.getCmp('uNameField').getValue());
            var uDescField = encodeURIComponent(Ext.getCmp('uDescField').getValue());
            
            var colTypeRadio=formPanel.getForm().findField('colTypeRadio').getValue().inputValue;
            var locTypeRadio=formPanel.getForm().findField('locTypeRadio').getValue().inputValue;
            var assessTypeRadio=formPanel.getForm().findField('assessTypeRadio').getValue().inputValue;
            var photoRadio=formPanel.getForm().findField('photoRadio').getValue().inputValue;
            
            var spcilRadio=formPanel.getForm().findField('spcilRadio').getValue().inputValue;
            var objTypeRadio=formPanel.getForm().findField('objTypeRadio').getValue().inputValue;
            var activeRadio=formPanel.getForm().findField('activeRadio').getValue().inputValue;
            var compRadio=formPanel.getForm().findField('compRadio').getValue().inputValue;
            if(uCodeField==""){
                Ext.Msg.show({title:'提示',msg:'代码不能为空!',width:200,icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
            }else if(uNameField==""){
                Ext.Msg.show({title:'提示',msg:'名称不能为空!',width:200,icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
            }else{
            
                var data="&code="+uCodeField+"&name="+uNameField+"&loctype="+locTypeRadio+"&coltype="+colTypeRadio+"&assesstype="+assessTypeRadio+"&desc="+uDescField+"&active="+activeRadio+"&photo="+photoRadio+"&spcil="+spcilRadio+"&objecttype="+objTypeRadio+"&comp="+compRadio;
                Ext.Ajax.request({
                    url:'dhc.qm.checkexe.csp?action=add&'+data,
                    success:function(result,request){
                        //console.log(result);
                        var jsonData = Ext.util.JSON.decode( result.responseText );
                        
                        if (jsonData.success=='true'){
                            Ext.Msg.show({title:'提示',msg:'添加成功!',width:200,icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
                            itemGrid.load({params:{start:0, limit:25}});
                        }else{
                            
                            Ext.Msg.show({title:'错误',msg:'添加失败!',width:200,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                            
                        }
                    },
                    failure:function(result, request){
                        Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                    },
                    scope: this
                });
            }
        }
    });
    //取消按钮
    var ucancleBtn = new Ext.Button({
        text:'取消',
        //iconCls:'',
        handler:function(){
            addWin.close();
        }
    });
        
//=================定义form表单==END========================//
    var formPanel = new Ext.form.FormPanel({
        frame:true,
        bodyStyle:'padding:5px 5px 0 5px',
        labelWidth:80,
        width:450,
        //height:200,
        items:[{
            layout:'form',
            items:[uCodeField,uNameField,uDescField,
            colTypeRadio,locTypeRadio,assessTypeRadio,objTypeRadio,
            activeRadio,photoRadio,spcilRadio,compRadio]
        }]
    });
    
    //弹出窗体
    var addWin = new Ext.Window({
        title:"添加检查点",
        plain : true,
        modal : true,
        //height:100,
        width:451,
        buttonAlign : 'center',
        items:[formPanel],
        buttons: [usaveBtn,ucancleBtn]
    });
    
        addWin.show();
        
    };