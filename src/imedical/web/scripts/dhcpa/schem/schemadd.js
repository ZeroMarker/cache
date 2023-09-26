addSchemFun = function(dataStore,grid,pagingTool) {

var monthField = new Ext.form.ComboBox({
            id:'monthField',
            fieldLabel: '����Ƶ��',
            anchor: '90%',
            editable:false,
            valueField: 'rowid',
            displayField:'name',
            mode:'local',
            triggerAction:'all',
            store:new Ext.data.SimpleStore({
                fields:['rowid','name'],
                data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
            })          
        });

var appSysField = new Ext.form.ComboBox({
            id:'appSysField',
            fieldLabel: 'Ӧ��ϵͳ��',
            editable:false,
            anchor: '90%',
            valueField: 'rowid',
            displayField:'name',
            mode:'local',
            triggerAction:'all',
            store:new Ext.data.SimpleStore({
                fields:['rowid','name'],
                data:[['2','����']]
                //data:[['1','ȫԺ'],['2','����'],['3','����'],['4','ҽ��'],['5','����']]
            })          
        });

var KPIIndexDs = new Ext.data.Store({
    proxy:KPIIndexProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
            'rowid','name'
 
        ]),
    remoteSort: true
});
KPIIndexDs.on('beforeload', function(ds, o){
    ds.proxy=new Ext.data.HttpProxy({url:KPIIndexUrl+'?action=kpi&&start=0&limit=999'});
});

/*
var KPIIndexField = new Ext.form.ComboBox({
    id: 'KPIIndexField',
    fieldLabel: '���ָ��',
    width:230,
    listWidth : 230,
    //allowBlank: false,
    store: KPIIndexDs,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText:'��ѡ��ָ��...',
    name: 'KPIIndexField',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true
});
*/
    
var KPIIndexField = new Ext.ux.form.LovCombo({
    id: 'KPIIndexField',
    fieldLabel: '���ָ��',
    anchor: '90%',
    //allowBlank: false,
    store: KPIIndexDs,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText:'��ѡ��ָ��...',
    name: 'KPIIndexField',
    minChars: 1,
    //pageSize: 10,
    //selectOnFocus:true,
    //forceSelection:true,
    editable:false
}); 
    
    /////////////////////////////////////////////////////////////
    
    
    
    
    var codeField = new Ext.form.TextField({
        id: 'codeField',
        fieldLabel: '��������',
        allowBlank: true,
        emptyText:'��ӷ�������...',
        anchor: '90%'
    });
    
    var nameField = new Ext.form.TextField({
        id: 'nameField',
        fieldLabel: '��������',
        allowBlank: true,
        emptyText:'��ӷ�������...',
        anchor: '90%'
    });

    //////////////����ʽ///////////////////////////
    
    
    var computeTypeField = new Ext.form.ComboBox({
            id:'computeTypeField',
            fieldLabel: '����ʽ',
            editable:false,
            anchor: '90%',
            valueField: 'rowid',
            displayField:'name',
            mode:'local',
            triggerAction:'all',
            store:new Ext.data.SimpleStore({
                fields:['rowid','name'],
                data:[['1','���д���ʽ'],['2','���⴦��ʽ'],['3','����ʽ']]
            })          
        });
        
        var SchemTypeField = new Ext.form.ComboBox({
            id:'schemTypeField',
            fieldLabel: '��������',
            editable:false,
            anchor: '90%',
            valueField: 'rowid',
            displayField:'name',
            mode:'local',
            triggerAction:'all',
            store:new Ext.data.SimpleStore({
                fields:['rowid','name'],
                data:[['Y','�����ʾ�'],['N','һ�㷽��']]
            })          
        });
    
    ////////////////�ϼ�����////////////////////////

    
        var schemDs = new Ext.data.Store({
            proxy: "",
            reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','desc'])
        });

        schemDs.on('beforeload', function(ds, o){
            ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.userschemauditexe.csp?action=schem&start=0&limit=10000',method:'GET'});
        });
    
        var upschemCombo = new Ext.ux.form.LovCombo({
            id:'upschemCombo',
            fieldLabel:'�ϼ�����',
            store: schemDs,
            displayField:'name',
            valueField:'rowid',
            //typeAhead: true,
            //forceSelection: true,
            name:'upschemCombo',
            triggerAction: 'all',
            emptyText:'ѡ��...',
            listWidth : 230,
            //pageSize: 10,
            minChars: 1,
            anchor: '90%',
            editable:false
            //selectOnFocus:true
            
        });
    
    /////////////////////////////////////

    
    // create form panel
  var formPanel = new Ext.form.FormPanel({
    baseCls: 'x-plain',
    labelWidth: 80,
    items: [
            codeField,
            nameField,
            monthField,
          //  appSysField,
            KPIIndexField,

            computeTypeField,
            upschemCombo//,
           // SchemTypeField
            
        ]
    });

  // define window and show it in desktop
  var window = new Ext.Window({
    title: '��ӷ���',
    width: 380,
    height:250,
    minWidth: 380,
    minHeight: 250,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
        text: '����',
        handler: function() {
            // check form value
            
            var code = codeField.getValue();
            var name = encodeURIComponent(nameField.getValue());
            var appSys = 2;//appSysField.getValue();
            var month = monthField.getValue();
            var kpi = KPIIndexField.getValue();
            
            code = code.trim();
            name = name.trim();
            
            
            var computeType =computeTypeField.getValue();
            var upschem = upschemCombo.getValue();
            var flag =  "N";//SchemTypeField.getValue();
            //alert(upschem);
            //alert(name);
            var data = code+'^'+name+'^'+appSys+'^'+month+'^'+kpi+'^'+computeType+'^'+upschem+"^"+flag;
            //alert(data);
            if (formPanel.form.isValid()) {
            
                    if(code =="")
                        {
                            Ext.Msg.show({title:'��ʾ',msg:'����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
                            return;
                        }
                    if(name =="")
                        {
                            Ext.Msg.show({title:'��ʾ',msg:'����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
                            return;
                        }
                    if(month =="")
                        {
                            Ext.Msg.show({title:'��ʾ',msg:'��ѡ�񿼺�Ƶ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
                            return;
                        }
                    if(appSys =="")
                        {
                            Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Ӧ��ϵͳ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
                            return;
                        }
                    if(computeType =="")
                        {
                            Ext.Msg.show({title:'��ʾ',msg:'��ѡ����ʽ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
                            return;
                        }
                    if(flag =="")
                        {
                            Ext.Msg.show({title:'��ʾ',msg:'��ѡ�񷽰�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
                            return;
                        }
                        //encodeURIComponent
                                    Ext.Ajax.request({
                            url: 'dhc.pa.schemexe.csp?action=add&data='+data,
                            failure: function(result, request) {
                                Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                            },
                            success: function(result, request) {
                                var jsonData = Ext.util.JSON.decode( result.responseText );
                            if (jsonData.success=='true') {
                                Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                                    dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
                                    //window.close();
                                }
                                else
                                {
                                    var message = "";
                                    // message = "SQLErr: " + jsonData.info;
									message = "ѡ��Ľ��ָ��������࣡ ";
                                    if(jsonData.info=='EmptyRecData') message='���������Ϊ��!';
                                    if(jsonData.info=='RepCode') message='�����ظ�!';
                                    if(jsonData.info=='RepName') message='�����ظ�!';
                                  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                                }
                            },
                        scope: this
                        });
            }
            else{
                        Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                    }
            }
        },
        {
                text: 'ȡ��',
        handler: function(){window.close();}
      }]
    });

    window.show();
};