/**����ά����ӹ��ܵ�����
* cyl 2016-05-04
**/


//��д����е�add���� 2016-05-04 cyl add
dhc.herp.Grid.prototype.add=function(){
    //==================����form��==START======================//

var uCodeField = new Ext.form.TextField({
        id: 'uCodeField',
        fieldLabel: '�������',
        width:325,
        allowBlank:false,
        triggerAction: 'all',
        emptyText:'����д�������',
        minChars: 1,
        editable:true
    });
var uNameField = new Ext.form.TextField({
    id:'uNameField',
    fieldLabel: '��������',
    width:325,
    allowBlank:false,
    triggerAction:'all',
    emptyText:'����д��������',
    minChars:1,
    editable:true
    
});
var uDescField = new Ext.form.TextArea({
    id:'uDescField',
    fieldLabel: '��������',
    width:325,
    allowBlank:false,
    triggerAction:'all',
    //emptyText:'����д��������',
    //minChars:1,
    editable:true
    
});
var colTypeRadio= new Ext.form.RadioGroup({
    name:'colTypeRadio',
    fieldLabel:'�ռ���ʽ',
    columns:4,
    items:[{
        boxLabel:'¼��',
        inputValue:'1',
        name:'colTypeRadio',
        style:'height:14px'
    },{
        boxLabel:'�ɼ�',
        inputValue:'2',
        name:'colTypeRadio',
        style:'height:14px'
    },{
        boxLabel:'����',
        inputValue:'3',
        name:'colTypeRadio',
        style:'height:14px'
    },{
        boxLabel:'Excel����',
        inputValue:'1',
        name:'colTypeRadio',
        style:'height:14px',
        checked:true
    }]
});
var locTypeRadio= new Ext.form.RadioGroup({
    name:'locTypeRadio',
    fieldLabel:'�������',
    columns:4,
    items:[{
        boxLabel:'��ѡ�����',
        inputValue:'1',
        name:'locTypeRadio',
        style:'height:14px',
        checked:true
    },{
        boxLabel:'���б����',
        inputValue:'2',
        name:'locTypeRadio',
        style:'height:14px'
    }]
});
var assessTypeRadio= new Ext.form.RadioGroup({
    name:'assessTypeRadio',
    fieldLabel:'��������',
    columns:4,
    items:[{
        boxLabel:'ѡ��',
        inputValue:'1',
        name:'assessTypeRadio',
        style:'height:14px',
        checked:true
    },{
        boxLabel:'�ı�',
        inputValue:'2',
        name:'assessTypeRadio',
        style:'height:14px'
    }]
});
var photoRadio= new Ext.form.RadioGroup({
    name:'photoRadio',
    fieldLabel:'�Ƿ�����',
    columns:4,
    items:[{
        boxLabel:'��',
        inputValue:'Y',
        name:'photoRadio',
        style:'height:14px',
        checked:true
    },{
        boxLabel:'��',
        inputValue:'N',
        name:'photoRadio',
        style:'height:14px'
    }]
});
var spcilRadio= new Ext.form.RadioGroup({
    name:'spcilRadio',
    fieldLabel:'����ָʾ',
    columns:4,
    items:[{
        boxLabel:'��',
        inputValue:'Y',
        name:'spcilRadio',
        style:'height:14px',
        checked:true
    },{
        boxLabel:'��',
        inputValue:'N',
        name:'spcilRadio',
        style:'height:14px'
    }]
});
var objTypeRadio= new Ext.form.RadioGroup({
    name:'objTypeRadio',
    fieldLabel:'����������',
    columns:4,
    items:[{
        boxLabel:'����',
        inputValue:'1',
        name:'objTypeRadio',
        style:'height:14px'
        
    },{
        boxLabel:'����',
        inputValue:'2',
        name:'objTypeRadio',
        style:'height:14px',
        checked:true
    }]
});
var activeRadio=new Ext.form.RadioGroup({
        name:'activeRadio',
        fieldLabel:'�Ƿ���Ч',
        columns: 4,
        items:[{
            boxLabel:'��',
            inputValue:'Y',
            name:'activeRadio',
            style:'height:14px;',
            checked:true
        },{
            boxLabel:'��',
            inputValue:'N',
            style:'height:14px;',
            name:'activeRadio'
        }]
    });
var compRadio=new Ext.form.RadioGroup({
        name:'compRadio',
        fieldLabel:'���뿼��',
        columns: 4,
        items:[{
            boxLabel:'��',
            inputValue:'Y',
            name:'compRadio',
            style:'height:14px;',
            checked:true
        },{
            boxLabel:'��',
            inputValue:'N',
            style:'height:14px;',
            name:'compRadio'
        }]
    });

//���水ť
    var usaveBtn = new Ext.Button({
        text:'����',
        //iconCls:'save',
        handler:function(){
            
            //��ȡֵ
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
                Ext.Msg.show({title:'��ʾ',msg:'���벻��Ϊ��!',width:200,icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
            }else if(uNameField==""){
                Ext.Msg.show({title:'��ʾ',msg:'���Ʋ���Ϊ��!',width:200,icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
            }else{
            
                var data="&code="+uCodeField+"&name="+uNameField+"&loctype="+locTypeRadio+"&coltype="+colTypeRadio+"&assesstype="+assessTypeRadio+"&desc="+uDescField+"&active="+activeRadio+"&photo="+photoRadio+"&spcil="+spcilRadio+"&objecttype="+objTypeRadio+"&comp="+compRadio;
                Ext.Ajax.request({
                    url:'dhc.qm.checkexe.csp?action=add&'+data,
                    success:function(result,request){
                        //console.log(result);
                        var jsonData = Ext.util.JSON.decode( result.responseText );
                        
                        if (jsonData.success=='true'){
                            Ext.Msg.show({title:'��ʾ',msg:'��ӳɹ�!',width:200,icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
                            itemGrid.load({params:{start:0, limit:25}});
                        }else{
                            
                            Ext.Msg.show({title:'����',msg:'���ʧ��!',width:200,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                            
                        }
                    },
                    failure:function(result, request){
                        Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                    },
                    scope: this
                });
            }
        }
    });
    //ȡ����ť
    var ucancleBtn = new Ext.Button({
        text:'ȡ��',
        //iconCls:'',
        handler:function(){
            addWin.close();
        }
    });
        
//=================����form��==END========================//
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
    
    //��������
    var addWin = new Ext.Window({
        title:"��Ӽ���",
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