//uploadPanel.js
var keel={};  
  
keel.UploadPanel = function(cfg){  
    this.width = 510;  
    this.height = 200;  
    Ext.apply(this,cfg);      
    this.gp = new Ext.grid.EditorGridPanel({//�޸�Ϊ�ɱ༭���  
        border :false,  
        selModel: new Ext.grid.RowSelectionModel({  
  
        }),  
        store: new Ext.data.Store({  
            fields:['id','name','type','size','state','percent','detail']  
        }),  
        columns: [  
            new Ext.grid.RowNumberer(),  
            {header: '�ļ���', width: 150, sortable: true,dataIndex: 'name', menuDisabled:true},  
            {header: '����', width: 50, sortable: true,dataIndex: 'type', menuDisabled:true},  
            {header: '��С', width: 70, sortable: true,dataIndex: 'size', menuDisabled:true,renderer:this.formatFileSize},  
            {header: '�ļ�˵��', width: 100, sortable: true,dataIndex: 'detail', menuDisabled:true,editor: {xtype: 'textfield'}},//-------�����޸�------  
            {header: '����', width: 150, sortable: true,dataIndex: 'percent', menuDisabled:true,renderer:this.formatProgressBar,scope:this},  
            {header: '״̬', width: 70, sortable: true,dataIndex: 'state', menuDisabled:true,renderer:this.formatFileState,scope:this},  
            {header: ' ',width:40,dataIndex:'id', menuDisabled:true,renderer:this.formatDelBtn}         
        ]             
    });  
    this.setting = {  
        upload_url : this.uploadUrl,   
        flash_url : this.flashUrl,  
        file_size_limit : this.fileSize || (1024*50) ,//�ϴ��ļ�������ޣ���λMB  
        file_post_name : this.filePostName,  
        file_types : this.fileTypes||"*.*",  //�����ϴ����ļ�����   
        file_types_description : "All Files",  //�ļ���������  
        file_upload_limit : "0",  //�޶��û�һ��������ϴ����ٸ��ļ������ϴ������У������ֻ��ۼӣ��������Ϊ��0�������ʾû������   
        //file_queue_limit : "10",//�ϴ������������ƣ�����ͨ���������ã������file_upload_limit�Զ���ֵ                
        post_params : this.postParams||{Detail:'ok'} ,  
        use_query_string : true,  
        debug : false,  
        button_cursor : SWFUpload.CURSOR.HAND,  
        button_window_mode : SWFUpload.WINDOW_MODE.TRANSPARENT,  
        custom_settings : {//�Զ������  
            scope_handler : this  
        },  
        file_queued_handler : this.onFileQueued,  
        swfupload_loaded_handler : function(){},// ��Flash�ؼ��ɹ����غ󴥷����¼�������  
        file_dialog_start_handler : function(){},// ���ļ�ѡȡ�Ի��򵯳�ǰ�������¼�������  
        file_dialog_complete_handler : this.onDiaogComplete,//���ļ�ѡȡ�Ի���رպ󴥷����¼�����  
        upload_start_handler : this.onUploadStart,// ��ʼ�ϴ��ļ�ǰ�������¼�������  
        upload_success_handler : this.onUploadSuccess,// �ļ��ϴ��ɹ��󴥷����¼�������   
        swfupload_loaded_handler : function(){},// ��Flash�ؼ��ɹ����غ󴥷����¼�������    
        upload_progress_handler : this.uploadProgress,  
        upload_complete_handler : this.onUploadComplete,  
        upload_error_handler : this.onUploadError,  
        file_queue_error_handler : this.onFileError  
    };  
    keel.UploadPanel.superclass.constructor.call(this,{               
        tbar : [  
            {text:'����ļ�',iconCls:'btn-add',icon:'../scripts/Pmp/Image/add.png',ref:'../addBtn'},'-',  
            {text:'�ϴ�',icon:'../scripts/Pmp/Image/upload-start.gif',iconCls:'btn-up',ref:'../uploadBtn',handler:this.startUpload,scope:this},'-',  
            {text:'ֹͣ�ϴ�',icon:'../scripts/Pmp/Image/upload-stop.gif',iconCls:'btn-cancel',ref:'../stopBtn',handler:this.stopUpload,scope:this,disabled:true},'-',  
            {text:'ɾ������',icon:'../scripts/Pmp/Image/delete.png',ref:'../deleteBtn',iconCls:'btn-clear',handler:this.deleteAll,scope:this},'-'  
        ],  
        layout : 'fit',  
        items : [this.gp],  
        listeners : {  
            'afterrender':function(){  
                var em = this.getTopToolbar().get(0).el.child('em');  
                var placeHolderId = Ext.id();  
                em.setStyle({  
                    position : 'relative',  
                    display : 'block'  
                });  
                em.createChild({  
                    tag : 'div',  
                    id : placeHolderId  
                });  
                this.swfupload = new SWFUpload(Ext.apply(this.setting,{  
                    button_width : em.getWidth(),  
                    button_height : em.getHeight(),  
                    button_placeholder_id :placeHolderId  
                }));  
                this.swfupload.uploadStopped = false;  
                Ext.get(this.swfupload.movieName).setStyle({  
                    position : 'absolute',  
                    top : 0,  
                    left : 0  
                });               
            },  
            scope : this,  
            delay : 100  
        }  
    });  
}  
Ext.extend(keel.UploadPanel,Ext.Panel,{  
    toggleBtn :function(bl){  
        this.addBtn.setDisabled(bl);  
        this.uploadBtn.setDisabled(bl);  
        this.deleteBtn.setDisabled(bl);  
        this.stopBtn.setDisabled(!bl);  
        this.gp.getColumnModel().setHidden(7,bl);  
    },  
    onUploadStart : function(file) {    
       var post_params = this.settings.post_params;   
       alert(post_params); 
       Ext.apply(post_params,{//�������Ĳ�������  
            //fileName : file.name,  
            fileName : encodeURIComponent(file.name)  
       });    
       this.setPostParams(post_params); //-------�����޸�------  
       var det="";  
       var me = this.customSettings.scope_handler;  
       var ds = me.gp.store;  
       for(var i=0;i<ds.getCount();i++){  
            var record =ds.getAt(i);  
            if(record.get('id')==file.id)  
                det=record.get('detail');  
       }  
       this.addFileParam(file.id ,"detail",det);//-------�����޸�------  
    },  
    startUpload : function() {  
        if (this.swfupload) {  
            if (this.swfupload.getStats().files_queued > 0) {  
                this.swfupload.uploadStopped = false;  
                this.toggleBtn(true);  
                this.swfupload.startUpload();  
            }  
        }  
    },  
    formatFileSize : function(_v, celmeta, record) {  
        return Ext.util.Format.fileSize(_v);  
    },  
    formatFileState : function(n){//�ļ�״̬  
        switch(n){//-------�����޸�------  
            case -1 : return '<img src="/skin/images/152.png"/><span style="color:green;">  δ�ϴ�</span>';  
            break;  
            case -2 : return '<img src="/skin/images/147.png"/><span style="color:brown;">  �����ϴ�</span>';  
            break;  
            case -3 : return '<img src="/skin/images/151.png"/><span style="color:red;">  �ϴ�ʧ��</span>';  
            break;  
            case -4 : return '<img src="/skin/images/102.png"/><span style="color:green;">  �ϴ��ɹ�</span>';  
            break;  
            case -5 : return '<img src="/skin/images/050.png"/><span style="color:#CECEFF;">  ȡ���ϴ�</span>';  
            break;  
            default: return n;//-------�����޸�------  
        }  
    },  
    formatProgressBar : function(v){  
        var progressBarTmp = this.getTplStr(v);  
        return progressBarTmp;  
    },  
    getTplStr : function(v){  
        var bgColor = "orange";  
        var borderColor = "#008000";  
        return String.format(  
            '<div>'+  
                '<div style="border:1px solid {0};height:10px;width:{1}px;margin:4px 0px 1px 0px;float:left;">'+        
                    '<div style="float:left;background:{2};width:{3}%;height:10px;"><div></div></div>'+  
                '</div>'+  
            '<div style="text-align:center;float:right;width:40px;margin:3px 0px 1px 0px;height:10px;font-size:12px;">{3}%</div>'+            
        '</div>', borderColor,(90),bgColor, v);  
    },  
    onUploadComplete : function(file) {  
        var me = this.customSettings.scope_handler;  
        if(file.filestatus==-4){  
            var ds = me.gp.store;  
            for(var i=0;i<ds.getCount();i++){  
                var record =ds.getAt(i);  
                if(record.get('id')==file.id){  
                    record.set('percent', 100);  
                    if(record.get('state')!=-3){  
                        record.set('state', file.filestatus);  
                    }  
                    record.commit();  
                }  
            }  
        }  
          
        if (this.getStats().files_queued > 0 && this.uploadStopped == false) {  
            this.startUpload();  
        }else{            
            me.toggleBtn(false);  
            me.linkBtnEvent();  
        }         
    },  
    onFileQueued : function(file) {  
        var me = this.customSettings.scope_handler;  
        var rec = new Ext.data.Record({  
            id : file.id,  
            name : file.name,  
            size : file.size,  
            type : file.type,  
            state : file.filestatus,  
            percent : 0  
        })  
        me.gp.getStore().add(rec);  
    },  
    onUploadSuccess : function(file, serverData) {  
        var me = this.customSettings.scope_handler;  
        var ds = me.gp.store;  
        if (Ext.util.JSON.decode(serverData).success) {           
            for(var i=0;i<ds.getCount();i++){  
                var rec =ds.getAt(i);  
                if(rec.get('id')==file.id){  
                    rec.set('state', file.filestatus);  
                    rec.commit();  
                }  
            }             
        }else{  
            for(var i=0;i<ds.getCount();i++){  
                var rec =ds.getAt(i);  
                if(rec.get('id')==file.id){  
                    rec.set('percent', 0);  
                    rec.set('state', -3);  
                    rec.commit();  
                }  
            }  
        }  
        me.linkBtnEvent();  
        caF(file,serverData);//�ϴ��ɹ�������Զ��庯��  
    },  
    uploadProgress : function(file, bytesComplete, totalBytes){//���������  
        var me = this.customSettings.scope_handler;  
        var percent = Math.ceil((bytesComplete / totalBytes) * 100);  
        percent = percent == 100? 99 : percent;  
        var ds = me.gp.store;  
        for(var i=0;i<ds.getCount();i++){  
            var record =ds.getAt(i);  
            if(record.get('id')==file.id){  
                record.set('percent', percent);  
                record.set('state', file.filestatus);  
                record.commit();  
            }  
        }  
    },  
    onUploadError : function(file, errorCode, message) {  
        var me = this.customSettings.scope_handler;  
        me.linkBtnEvent();  
        var ds = me.gp.store;  
        for(var i=0;i<ds.getCount();i++){  
            var rec =ds.getAt(i);  
            if(rec.get('id')==file.id){  
                rec.set('percent', 0);  
                rec.set('state', file.filestatus);  
                rec.commit();  
            }  
        }  
    },  
    onFileError : function(file,n){  
        switch(n){  
            case -100 : tip('���ϴ��ļ��б��������ޣ�����ѡ��');  
            break;  
            case -110 : tip('�ļ�̫�󣬲���ѡ��');  
            break;  
            case -120 : tip('���ļ���СΪ0������ѡ��');  
            break;  
            case -130 : tip('���ļ����Ͳ������ϴ���');  
            break;  
        }  
        function tip(msg){  
            Ext.Msg.show({  
                title : '��ʾ',  
                msg : msg,  
                icon : Ext.Msg.WARNING,  
                buttons :Ext.Msg.OK  
            });  
        }  
    },  
    onDiaogComplete : function(){  
        var me = this.customSettings.scope_handler;  
        me.linkBtnEvent();  
    },  
    stopUpload : function() {  
        if (this.swfupload) {  
            this.swfupload.uploadStopped = true;  
            this.swfupload.stopUpload();  
        }  
    },  
    deleteAll : function(){  
        var ds = this.gp.store;  
        for(var i=0;i<ds.getCount();i++){  
            var record =ds.getAt(i);  
            var file_id = record.get('id');  
            this.swfupload.cancelUpload(file_id,false);           
        }  
        ds.removeAll();  
        this.swfupload.uploadStopped = false;  
    },  
    formatDelBtn : function(v){  
        return "<a href='#' id='"+v+"'  style='color:blue' class='link-btn' ext:qtip='�Ƴ����ļ�'>�Ƴ�</a>";  
    },  
    linkBtnEvent : function(){  
        Ext.select('a.link-btn',false,this.gp.el.dom).on('click',function(o,e){  
            var ds = this.gp.store;  
            for(var i=0;i<ds.getCount();i++){  
                var rec =ds.getAt(i);  
                if(rec.get('id')==e.id){  
                    ds.remove(rec);  
                }  
            }             
            this.swfupload.cancelUpload(e.id,false);  
        },this);  
    }  
});  
Ext.reg('uploadPanel',keel.UploadPanel);  