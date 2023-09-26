addSchemFun = function(dataStore,grid,pagingTool) {

var monthField = new Ext.form.ComboBox({
            id:'monthField',
            fieldLabel: '考核频率',
            anchor: '90%',
            editable:false,
            valueField: 'rowid',
            displayField:'name',
            mode:'local',
            triggerAction:'all',
            store:new Ext.data.SimpleStore({
                fields:['rowid','name'],
                data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
            })          
        });

var appSysField = new Ext.form.ComboBox({
            id:'appSysField',
            fieldLabel: '应用系统号',
            editable:false,
            anchor: '90%',
            valueField: 'rowid',
            displayField:'name',
            mode:'local',
            triggerAction:'all',
            store:new Ext.data.SimpleStore({
                fields:['rowid','name'],
                data:[['2','科室']]
                //data:[['1','全院'],['2','科室'],['3','护理'],['4','医疗'],['5','个人']]
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
    fieldLabel: '结果指标',
    width:230,
    listWidth : 230,
    //allowBlank: false,
    store: KPIIndexDs,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText:'请选择指标...',
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
    fieldLabel: '结果指标',
    anchor: '90%',
    //allowBlank: false,
    store: KPIIndexDs,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText:'请选择指标...',
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
        fieldLabel: '方案编码',
        allowBlank: true,
        emptyText:'添加方案编码...',
        anchor: '90%'
    });
    
    var nameField = new Ext.form.TextField({
        id: 'nameField',
        fieldLabel: '方案名称',
        allowBlank: true,
        emptyText:'添加方案名称...',
        anchor: '90%'
    });

    //////////////处理方式///////////////////////////
    
    
    var computeTypeField = new Ext.form.ComboBox({
            id:'computeTypeField',
            fieldLabel: '处理方式',
            editable:false,
            anchor: '90%',
            valueField: 'rowid',
            displayField:'name',
            mode:'local',
            triggerAction:'all',
            store:new Ext.data.SimpleStore({
                fields:['rowid','name'],
                data:[['1','现有处理方式'],['2','特殊处理方式'],['3','差额处理方式']]
            })          
        });
        
        var SchemTypeField = new Ext.form.ComboBox({
            id:'schemTypeField',
            fieldLabel: '方案类型',
            editable:false,
            anchor: '90%',
            valueField: 'rowid',
            displayField:'name',
            mode:'local',
            triggerAction:'all',
            store:new Ext.data.SimpleStore({
                fields:['rowid','name'],
                data:[['Y','调查问卷'],['N','一般方案']]
            })          
        });
    
    ////////////////上级方案////////////////////////

    
        var schemDs = new Ext.data.Store({
            proxy: "",
            reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','desc'])
        });

        schemDs.on('beforeload', function(ds, o){
            ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.userschemauditexe.csp?action=schem&start=0&limit=10000',method:'GET'});
        });
    
        var upschemCombo = new Ext.ux.form.LovCombo({
            id:'upschemCombo',
            fieldLabel:'上级方案',
            store: schemDs,
            displayField:'name',
            valueField:'rowid',
            //typeAhead: true,
            //forceSelection: true,
            name:'upschemCombo',
            triggerAction: 'all',
            emptyText:'选择...',
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
    title: '添加方案',
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
        text: '保存',
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
                            Ext.Msg.show({title:'提示',msg:'代码为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
                            return;
                        }
                    if(name =="")
                        {
                            Ext.Msg.show({title:'提示',msg:'名称为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
                            return;
                        }
                    if(month =="")
                        {
                            Ext.Msg.show({title:'提示',msg:'请选择考核频率!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
                            return;
                        }
                    if(appSys =="")
                        {
                            Ext.Msg.show({title:'提示',msg:'请选择应用系统号!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
                            return;
                        }
                    if(computeType =="")
                        {
                            Ext.Msg.show({title:'提示',msg:'请选择处理方式!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
                            return;
                        }
                    if(flag =="")
                        {
                            Ext.Msg.show({title:'提示',msg:'请选择方案类型!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
                            return;
                        }
                        //encodeURIComponent
                                    Ext.Ajax.request({
                            url: 'dhc.pa.schemexe.csp?action=add&data='+data,
                            failure: function(result, request) {
                                Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                            },
                            success: function(result, request) {
                                var jsonData = Ext.util.JSON.decode( result.responseText );
                            if (jsonData.success=='true') {
                                Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                                    dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
                                    //window.close();
                                }
                                else
                                {
                                    var message = "";
                                    // message = "SQLErr: " + jsonData.info;
									message = "选择的结果指标个数过多！ ";
                                    if(jsonData.info=='EmptyRecData') message='输入的数据为空!';
                                    if(jsonData.info=='RepCode') message='代码重复!';
                                    if(jsonData.info=='RepName') message='名称重复!';
                                  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                                }
                            },
                        scope: this
                        });
            }
            else{
                        Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                    }
            }
        },
        {
                text: '取消',
        handler: function(){window.close();}
      }]
    });

    window.show();
};