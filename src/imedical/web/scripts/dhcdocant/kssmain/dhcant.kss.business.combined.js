CombinedUse=function(EpisodeId,ParrAllInfo){
    this.EpisodeId=EpisodeId
    this.ParrAllInfo=ParrAllInfo
    //alert(this.KssOrdPriRowid)
    var Chrflag=false;
    var Curflag=false;
    debugger;
    var MaxNumObj=ExtTool.StaticServerObject("DHCAnt.KSS.Combined");
    var MaxNum=MaxNumObj.GetCombinedNumFormDAUP(this.EpisodeId,ParrAllInfo);
    var CurReaObj=ExtTool.StaticServerObject("DHCAnt.KSS.Combined");
    var CurRearet=CurReaObj.GetCombinedNumFormDAUP(this.EpisodeId,this.ParrAllInfo);
    if(CurRearet.split("|")[0] > 1){	//QP 20170622
        Curflag=true;
    }
    var ChrReaObj=ExtTool.StaticServerObject("DHCAnt.KSS.Combined");
    var Chrret=ChrReaObj.IfChangeFormDAUP(this.EpisodeId,this.ParrAllInfo)
    if (Chrret==1){
        Chrflag=true;
    }
    if(Curflag){this.CombinedUseInfo="<font color='red'><B>��Ҫ��д����ԭ��</B></font>"+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+"<font color='red'><B>����Ҫ��д���ԭ��</B></font>";}
    if(Chrflag){this.CombinedUseInfo="<font color='red'><B>����Ҫ��д����ԭ��</B></font>"+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+"<font color='red'><B>��Ҫ��д���ԭ��</B></font>";}
    if(Curflag&&Chrflag){this.CombinedUseInfo="<font color='red'><B>��Ҫ��д����ԭ��</B></font>"+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+"<font color='red'><B>��Ҫ��д���ԭ��</B></font>";}
    this.baseInfo=new Ext.form.FieldSet({
            title: '��ǰ�������',
            collapsible: true,  //��������Ƿ���۵�
            //collapsed: true,    //Ĭ�����ص�
            autoHeight:true,
			iconCls:"c-baseinfo-icon",
            defaultType: 'label',
            labelWidth:250,
            items :[/*{
                    fieldLabel: '��ǰ����ҩ��������'
                    ,html:"<font color='blue'><B>"+MaxNum+"</B></font>"     // ��ǰ��������
                },*/{
                    fieldLabel: '������������Ҫ��д��Ϣ',
                    html: this.CombinedUseInfo                 
                }] 

   });
   
    this.btnSave = new Ext.Button({
                id : 'btnSave'
                ,text : '����',
                iconCls:"c-btn-save",
                scope:this,
                handler: function(){
                this.SaveData()            
            }
  });
  this.btnCancel=new Ext.Button({
                id:'btnCancel',
                text:'ȡ��',
                iconCls:'c-btn-cancel',
                scope:this,
                handler:function(){
                    this.CloseWin();
                        //window.close();
                }
  });
  this.panel = new Ext.Panel({
            layout:'fit',
			buttonAlign : 'center',
            autoScroll:true,
            frame:true,
            items : [this.baseInfo],
            buttons:[this.btnSave,this.btnCancel]
  });
  CombinedUse.superclass.constructor.call(this,{
                region : 'center',
                closeAction:'close',
                resizable:false,
                closable:true,
                modal:true,
                items:[this.panel]
  });
  this.CombinedUseReason=new CombinedUseReason(this.EpisodeId,this.ParrAllInfo);
  this.panel.add(this.CombinedUseReason);
    

}
Ext.extend(CombinedUse,Ext.Panel,{
    //CombinedUseReturn: "",
    CloseWin:function(){
        if (!SaveFlag){
                    var flag=confirm("�ǼǱ�δ����,�Ƿ�����˳�?",true)
                    if(flag){
                        this.CombinedUseReturn=""
                      window.close();
                    }  
        }
            window.returnValue = this.CombinedUseReturn;
            return;
    },SaveData:function(){
        if (!this.CombinedUseReason.CheckBeforeUpdate()){ 
            return;
        }else{
            var Parargn=this.CombinedUseReason.GetReason();
            var ParargnArr=Parargn.split("^")
            var CurInfo=ParargnArr[0]
            var ChrInfo=ParargnArr[1]
        }
        var InsertObj=ExtTool.StaticServerObject("DHCAnt.KSS.Combined");
        var ret=InsertObj.SaveCombinedInfo(this.EpisodeId,this.ParrAllInfo,CurInfo,ChrInfo);
        if(ret!=0){
                alert("����ɹ�!"); 
                
                window.returnValue = true;
                window.close();
                return;
            }else{
                alert("������Ϣ����ʧ��!"); 
                return;
                }
        
        
    }
})

Ext.reg('CombinedUseWindow',CombinedUse)


CombinedUseReason=function(EpisodeId,ParrAllInfo){
        this.EpisodeId=EpisodeId
        this.ParrAllInfo=ParrAllInfo
               //-----------------------------!!!!!!!!1!!!!!!!!!!!!!---------------------------------
        this.CombinedReasonProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
                url : ExtToolSetting.RunQueryPageURL
        }));

        this.CombinedReasonStore = new Ext.data.Store({
                proxy:this.CombinedReasonProxy,
                reader: new Ext.data.JsonReader({
                root: 'record',
                totalProperty: 'total',
                idProperty: 'id'
            }, 
            [
                {name: 'checked', mapping : 'checked'}
                ,{name: 'text', mapping: 'text'}
                ,{name: 'id', mapping: 'id'}
            ])
        });
        
        this.CombinedReason = new Ext.ux.form.LovCombo({
            id :'CombinedReason'
            ,minChars : 1
            ,store : this.CombinedReasonStore
            ,valueField : 'id'
            ,fieldLabel : "����ԭ��<font color='red'>*</font>",
            allowBlank:false,
            emptyText:"��ѡ������ԭ��"
            ,displayField : 'text'
            ,triggerAction : 'all',
            checkField:'checked',
            width:260,
            editable:false
        });
        this.CombinedReasonProxy.on('beforeload', function(objProxy, param){
            param.ClassName = 'DHCAnt.KSS.Combined';
            param.QueryName = 'QryCombinedUseReason';
            //param.Arg1 = 1;  //this.UserReason.getRawValue();
            param.ArgCnt=0;
        },this);
        var ChkCurObj=ExtTool.StaticServerObject("DHCAnt.KSS.Combined");
        this.ChkCurret=ChkCurObj.GetCombinedNumFormDAUP(this.EpisodeId,this.ParrAllInfo); 
        
        //alert(this.ChkCurret.split("|")[0])
        if(this.ChkCurret.split("|")[0] <= 1){	//QP 20170622
            this.CombinedReason.setDisabled(true);
            this.CombinedReason.setValue("");
            this.CombinedReason.setRawValue(""); 
        }else{
            this.CombinedReason.setDisabled(false);                                   
        }
      //-----------------------------!!!!!!!!!!!!!!!!!!!!!---------------------------------
        //------------------------------------------------------2
        this.ChangeKssReasonStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
                url : ExtToolSetting.RunQueryPageURL
        }));
        this.ChangeKssReasonStore=new Ext.data.Store({
                proxy:this.ChangeKssReasonStoreProxy,
                reader:new Ext.data.JsonReader({
                        root:'record',
                        totalProperty:'total',
                        idProperty:'id'
                        },
                        [
                                {name:'checked',mapping:'checked'},
                                {name:'id',mapping:'id'},
                                {name:'text',mapping:'text'}
                        ])  
        });
        this.ChangeKssReason = new Ext.ux.form.LovCombo({
            id :'ChangeKssReason'
            ,minChars : 1
            ,store : this.ChangeKssReasonStore
            ,valueField : 'id'
            ,fieldLabel : "���ԭ��<font color='red'>*</font>",
            //allowBlank:false,
            emptyText:"��ѡ����ԭ��..."
            ,displayField : 'text'
            ,triggerAction : 'all',
            width:260,
            editable:false
        });
        this.ChangeKssReasonStoreProxy.on('beforeload', function(objProxy, param){
            param.ClassName = 'DHCAnt.KSS.Combined';
            param.QueryName = 'QryChangeReason';
            param.ArgCnt=0;
      },this);
      var ChkChrObj=ExtTool.StaticServerObject("DHCAnt.KSS.Combined");
      this.ChkChrret=ChkChrObj.IfChangeFormDAUP(this.EpisodeId,this.ParrAllInfo);
        if(this.ChkChrret==0){
            this.ChangeKssReason.setDisabled(true);
            this.ChangeKssReason.setValue("");
            this.ChangeKssReason.setRawValue(""); 
        }else{
            this.ChangeKssReason.setDisabled(false);
        }
        //---------------------------------------3
this.CurKssInfoStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
                url : ExtToolSetting.RunQueryPageURL
        }));
        this.CurKssInfoStore=new Ext.data.Store({
                proxy:this.CurKssInfoStoreProxy,
                reader:new Ext.data.JsonReader({
                        root:'record',
                        totalProperty:'total'
                       // ,idProperty:'Rowid'
                        },
                        [
                                {name:'checked',mapping:'checked'},
                                {name:'Num',mapping:'Num'},
                                {name:'Status',mapping:'Status'},
                                {name:'ArcItmDesc',mapping:'ArcItm'},
                                {name:'PriorityDesc',mapping:'Priority'}
                        ])  
        });
        this.CurKssInfo=new Ext.grid.GridPanel({
                id:'CurKssInfo',
				iconCls:'c-consult-icon',
                title:'��ǰ���ÿ���ҩ��',
                store:this.CurKssInfoStore,
                viewConfig: {forceFit: true},
                height:200, 
                columns:[
                        {header:'���',dataIndex:'Num',width:30,sortable: true},
                        {header:'ҽ������',dataIndex:'ArcItmDesc',sortable: true},
                        {header:'ҽ������',dataIndex:'PriorityDesc',sortable: true},
                        {header:'ҽ��״̬',dataIndex:'Status',sortable: true}
                ]
        });
        this.CurKssInfoStoreProxy.on('beforeload', function(objProxy, param){
            param.ClassName = 'DHCAnt.KSS.Combined';
            param.QueryName = 'CombinedInfo';
            param.Arg1 = this.EpisodeId;
            param.Arg2 = this.ParrAllInfo;
            param.ArgCnt=2;
        },this);
                //---------------------------------------4
        this.ChaAntInfoStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
                url : ExtToolSetting.RunQueryPageURL
        }));
        this.ChaAntInfoStore=new Ext.data.Store({
                proxy:this.ChaAntInfoStoreProxy,
                reader:new Ext.data.JsonReader({
                        root:'record',
                        totalProperty:'total'
                        },
                        [
                                {name:'checked',mapping:'checked'},
                                {name:'ArcItmDesc',mapping:'ArcItm'},
                                {name:'Status',mapping:'Status'},
                                {name:'StopDate',mapping:'StopDate'}
                        ])  
        });
        this.ChaAntInfo=new Ext.grid.GridPanel({
                id:'ChaAntInfo',
				iconCls:'c-chantInfo-icon',
                title:'����ҩ�����ԭ��',
                store:this.ChaAntInfoStore,
                viewConfig: {forceFit: true},
                height:150,
                columns:[
                        {header:'ҽ��״̬',dataIndex:'Status',sortable: true},
                        {header:'ҩƷ����',dataIndex:'ArcItmDesc',sortable: true},
                        {header:'ͣҽ��ʱ��',dataIndex:'StopDate',sortable: true}
                ]
        });
        this.ChaAntInfoStoreProxy.on('beforeload', function(objProxy, param){
            param.ClassName = 'DHCAnt.KSS.Combined';
            param.QueryName = 'AntChange';
            param.Arg1 = this.EpisodeId;
            param.Arg2 = this.ParrAllInfo;
            param.ArgCnt=2;
        },this);
        
      this.ChangeKssReasonStore.load();
      this.CombinedReasonStore.load();
      this.CurKssInfoStore.load();
      this.ChaAntInfoStore.load()
        CombinedUseReason.superclass.constructor.call(this,{
                id:'CombinedUseReason',
                title:'����Ŀ��',
                autoHeight:true,
                layout:'form',
				iconCls:'c-useaim-icon',
                buttonAlign : 'center',
                labelAlign:"right",
                frame:true,
                labelWidth:100,
                items:[{
                     layout:'column',
                                items:[{
                                                columnWidth:.5,
                                                layout:'form',
												labelSeparator:'&nbsp',
                                                items:[
                                                    this.CombinedReason
                                                ]   
                                            },{
                                                columnWidth:.5,
                                                layout:'form',
												labelSeparator:'&nbsp',
                                                items:[
                                                    this.ChangeKssReason
                                                ]   
                                            }
                                        ]
                            }
                    ,this.CurKssInfo 
                    ,this.ChaAntInfo           
                ]
        });
      
}
Ext.extend(CombinedUseReason,Ext.FormPanel,{
        CheckBeforeUpdate:function(){
            //У������,������ϸ�,����false,���򷵻�true
            if(this.ChkCurret.split("|")[0] > 1){	//QP 20170622
                var CombinedReasonValue=this.CombinedReason.getValue();  
                if(CombinedReasonValue==""){
                    ExtTool.alert("��ʾ","����ԭ����Ϊ��!");
                    return  ;
                }
            }
            if(this.ChkChrret!=0){
                var ChangeKssReasonValue=this.ChangeKssReason.getValue();  
                if(ChangeKssReasonValue==""){
                    ExtTool.alert("��ʾ","���ԭ����Ϊ��!");
                    return  ;    
                }
            }
            return true;    
        },
        GetReason:function(){   
            //��֯���� 
            var CombinedReasonValue=""
            if(this.ChkCurret.split("|")[0]!=0){
                var CombinedReasonValue=this.CombinedReason.getValue();  
            }
            var ChangeKssReasonValue=""
            if(this.ChkChrret=!0){
                ChangeKssReasonValue=this.ChangeKssReason.getValue();  
            }
                var Para=CombinedReasonValue+"^"+ChangeKssReasonValue
                return Para;
        }
})
Ext.reg('CombinedUseReason',CombinedUseReason)

