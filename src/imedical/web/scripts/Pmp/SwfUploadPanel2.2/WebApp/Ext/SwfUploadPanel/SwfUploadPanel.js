// Create user extension namespace
Ext.namespace('Ext.ux');
/**
* @class Ext.ux.SwfUploadPanel
* @extends Ext.grid.GridPanel

*使小组提供能力使用多个文件上传SwfUpload的脚本。
*
* @author斯蒂芬·Wentz
* @author迈克尔·吉(原作者)
* @website http://www.brainbits.net
* @created 2008-02-26
* @version 0.5
*
* known_issues
使用* -进度条编码宽度。不确定该如何使100%在bbar
* -小组需要宽度/高度确定。不知道为什么它将身体不适
* -当面板是嵌套有时栏目模型并不总是显示出适合直到文件被补充说。渲染秩序的问题。
*
* @constructor
* @param {对象}配置配置对象
*/
Ext.ux.SwfUploadPanel = Ext.extend(Ext.grid.GridPanel, {
    
    /**
     * @cfg {Object} strings
     * All strings used by Ext.ux.SwfUploadPanel
     */
    strings: {
        text_add: '添加(s)',
        text_upload: '上传(u)',
        text_cancel: '取消(q)',
        text_clear: '清空(c)',
        text_progressbar: '进度条(p)',
        text_remove: '移去文件(d)',
        text_remove_sure: '你确定要从队列中删除这个文件?',
        text_error: '系统提示',
        text_uploading: '文件“{0}”上传进度:  (已上传{1} 总共 {2})',
        header_filename: '文件名(p)',
        header_size: '大小(z)',
        header_status: '状态(s)',
        header_CreateDate: '日期(d)',
        status: {
            0: '等待上传...',
            1: '<img src="..Ext/SwfUploadPanel/images/loading.gif" />上传中...',
            2: '上传成功',
            3: '出错了,上传异常',
            4: '已取消'
            
        },
        error_queue_exceeded: '选定的文件数超过了最多的{0}排队文件数。',
        error_queue_slots_0: '超出了排队文件数。',
        error_queue_slots_1: '只能进行一个文件排队。',
        error_queue_slots_2: '智能有{0} 文件排队。',
        error_size_exceeded: '选定的文件的大小超过允许的限{0}。',
        error_zero_byte_file: '选中的文件零字节。',
        error_invalid_filetype: '无效的提示选择。',
        error_file_not_found: '文件没发现，404错误.',
        error_security_error: '安全的错误，不可以发表的不同的url。'
    },
    
    /**
    * @cfg {布尔} single_select
    *真正的允许多个文件选择、假的为单独的文件的选择。
    *请注意这并不会影响允许的文件数量排队。
    *使用{ @link # file_queue_limit }参数改变允许文件数量排队。
    */
    single_select: false,
    /**
     * @cfg {布尔} confirm_delete
     *显示确认框在队列删除文件。
     */ 
    confirm_delete: true,
    /**
    * @cfg {字符串} file_types
    *允许的类型的文件,文件选择对话框。使用分号作为多file-types拼接。
     */ 
    file_types: "*.*",                   // Default allow all file types
    /**
    * @cfg {字符串} file_types
    *被显示的文字描述用户的文件浏览器对话框。
     */ 
    file_types_description: "All Files", // 
    /**
    * @cfg {字符串} file_size_limit
    * file_size_limit设置定义的最大允许的大小的一份文件就上传。
    *这设置接受的价值和单位。有效的单位B,科比、MB和GB。假如单位省略了默认的是科比。
    * 0的值(零)是interpretted是无限的。
     */ 
    file_size_limit: "102400",          // 默认大小限制 100MB
    /**
     * @cfg {String} file_upload_limit
     * Defines the number of files allowed to be uploaded by SWFUpload. 
     * This setting also sets the upper bound of the {@link #file_queue_limit} setting. 
     * 0的价值是interpretted是无限的。
     */ 
    file_upload_limit: "0",              // 默认没有上传限制
    /**
     * @cfg {String} file_queue_limit
     * Defines the number of unprocessed files allowed to be simultaneously queued.
     * 0的价值是interpretted是无限的。
     */ 
    file_queue_limit: "0",               // 默认没有队列限制
    /**
     * @cfg {String} file_post_name
     * file_post_name允许你设置的名称,价值把文件。
     */ 
    file_post_name: "Filedata",          // Default name
    /**
     * @cfg {String} flash_url
     * 完全绝对,或相关的网址闪光控制的swf文件。
     */ 
    flash_url: "swfupload.swf",       // 默认的url,相对于页面的url
    /**
     * @cfg {Boolean} debug
     * A boolean value that defines whether the debug event handler should be fired.
     */ 
    debug: false,
    
    // standard grid parameters
    autoExpandColumn: 'name',
    enableColumnResize: false,
    enableColumnMove: false,

    // private
    upload_cancelled: false,
        
    // private
    initComponent: function() {
        
        this.addEvents(
            /**
            * @event swfUploadLoaded
            *火灾后的闪光的目的就是载入
            * @param { Ext.grid.GridPanel }网格这个格网
             */
            'swfUploadLoaded',
            /**
            * @event swfUploadLoaded
            *火灾文件已被qeueud后
            * @param { Ext.grid.GridPanel }网格这个格网
            * @param {对象}档案文件对象产生的错误
             */
            'fileQueued',
            /**
            * @event startUpload
            *火灾在上传开始
            * @param { Ext.grid.GridPanel }网格这个格网
             */
            'startUpload',
            /**
            * @event fileUploadError
            *火灾上传后已经终止或取消
            * @param { Ext.grid.GridPanel }网格这个格网
            * @param {对象}档案文件对象产生的错误
            * @param {字符串}进行编码错误代码
            * @param {字符串}信息辅助错误信息
             */
            'fileUploadError',
            /**
            * @event fileUploadSuccess
            上传后*大火已成功上传
            * @param { Ext.grid.GridPanel }网格这个格网
            * @param {对象}档案文件对象已经上传
            * @param {对象}数据的响应数据上传的要求

             */
            'fileUploadSuccess',
            /**
            * @event fileUploadComplete
            *火灾后一个文件上传周期结束了
            * @param { Ext.grid.GridPanel }网格这个格网
            * @param {对象}档案文件对象已经上传
             */
            'fileUploadComplete',
            /**
            * @event fileUploadComplete
            *火灾上传后循环所有文件在队列中完成
            * @param { Ext.grid.GridPanel }网格这个格网
             */
            'allUploadsComplete',
            /**
            * @event fileUploadComplete
            *火灾之后的一个或多个文件已经从队列中移走了
            * @param { Ext.grid.GridPanel }网格这个格网
             */
            'removeFiles',
            /**
            * @event fileUploadComplete
            *火灾毕竟的文件已经从队列中移走了
            * @param { Ext.grid.GridPanel }网格这个格网
             */
            'removeAllFiles'
        );
        
        this.rec = Ext.data.Record.create([
             {name: 'name'},
             {name: 'size'},
             {name: 'id'},
             {name: 'type'},
             {name: 'creationdate', type: 'date', dateFormat: 'yyyy/MM/dd'},
             {name: 'status'}
        ]);
        
        this.store = new Ext.data.Store({
            reader: new Ext.data.JsonReader({
                  id: 'id'
             }, this.rec)
        });
        
        this.columns = [{
            id:'name', 
            header: this.strings.header_filename, 
            dataIndex: 'name'
        },{
            id:'size', 
            header: this.strings.header_size, 
            width: 100, 
            dataIndex: 'size', 
            renderer: this.formatBytes
        },{
            id:'status', 
            header: this.strings.header_status, 
            width: 100, 
            dataIndex: 'status', 
            renderer: this.formatStatus.createDelegate(this)
        }];
        
        this.sm = new Ext.grid.RowSelectionModel({
            singleSelect: this.single_select
        });


        this.progress_bar = new Ext.ProgressBar({
            text: this.strings.text_progressbar
//            width: this.width - 7
        }); 

        this.tbar = [{
            text: this.strings.text_add,
            iconCls: 'SwfUploadPanel_iconAdd',
            xhandler: function() {
                if (this.single_select) {
                    this.suo.selectFile();
                }
                else {
                    this.suo.selectFiles();
                }
            },
            xscope: this
        }, '->', {
            text: this.strings.text_cancel,
            iconCls: 'SwfUploadPanel_iconCancel',
            handler: this.stopUpload,
            scope: this,
            hidden: true
        }, {
            text: this.strings.text_upload,
            iconCls: 'SwfUploadPanel_iconUpload',
            handler: this.startUpload,
            scope: this,
            hidden: true
        }, {
            text: this.strings.text_clear,
            iconCls: 'SwfUploadPanel_iconClear',
            handler: this.removeAllFiles,
            scope: this,
            hidden: false
        }];
        
        this.bbar = [
            this.progress_bar
        ];
        
        this.addListener({
            keypress: {
                fn: function(e) {
                    if (this.confirm_delete) {
                        if(e.getKey() == e.DELETE) {
                            Ext.MessageBox.confirm(this.strings.text_remove,this.strings.text_remove_sure, function(e) {
                                if (e == 'yes') {
                                    this.removeFiles();
                                }
                            }, this);
                        }   
                    } else {
                        this.removeFiles(this);
                    }
                },
                scope: this
            },
            
            // Prevent the default right click to show up in the grid.
            contextmenu: function(e) {
                e.stopEvent();
            },
            
            render: {
                fn: function(){
                    this.resizeProgressBar();
                    
                    this.addBtn = this.getTopToolbar().items.items[0];
					this.cancelBtn = this.getTopToolbar().items.items[2];
                    this.uploadBtn = this.getTopToolbar().items.items[3];
                    this.clearBtn = this.getTopToolbar().items.items[4];
        
                    this.on('resize', this.resizeProgressBar, this);
                },
                scope: this
            }
        });
        

        this.on('render', function() {
            var suoID = Ext.id();
            var em = this.addBtn.el.child('em');
            em.setStyle({
                position: 'relative',
                display: 'block'
            });
            em.createChild({
                tag: 'div',
                id: suoID
            });
            this.suo = new SWFUpload({
                button_placeholder_id: suoID,
                button_width: em.getWidth(),
                button_height: em.getHeight(),
                button_cursor: SWFUpload.CURSOR.HAND,
                button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
                
                upload_url: this.upload_url,
                post_params: this.post_params,
                file_post_name: this.file_post_name,  
                file_size_limit: this.file_size_limit,
                file_queue_limit: this.file_queue_limit,
                file_types: this.file_types,
                file_types_description: this.file_types_description,
                file_upload_limit: this.file_upload_limit,
                flash_url: this.flash_url,   
        
                // Event Handler Settings
                swfupload_loaded_handler: this.swfUploadLoaded.createDelegate(this),
        
                file_dialog_start_handler: this.fileDialogStart.createDelegate(this),
                file_queued_handler: this.fileQueue.createDelegate(this),
                file_queue_error_handler: this.fileQueueError.createDelegate(this),
                file_dialog_complete_handler: this.fileDialogComplete.createDelegate(this),
                
                upload_start_handler: this.uploadStart.createDelegate(this),
                upload_progress_handler: this.uploadProgress.createDelegate(this),
                upload_error_handler: this.uploadError.createDelegate(this), 
                upload_success_handler: this.uploadSuccess.createDelegate(this),
                upload_complete_handler: this.uploadComplete.createDelegate(this),
        
                debug: this.debug,
                debug_handler: this.debugHandler
            });
            
            Ext.get(this.suo.movieName).setStyle({
                position: 'absolute', 
                top: 0,
                left: 0
            });
        }, this);
        
        Ext.ux.SwfUploadPanel.superclass.initComponent.call(this);
    },

    // private
    resizeProgressBar: function() {
        this.progress_bar.setWidth(this.getBottomToolbar().el.getWidth() - 5);
        Ext.fly(this.progress_bar.el.dom.firstChild.firstChild).applyStyles("height: 18px");
    },
    
    /**
     * SWFUpload debug handler
     * @param {Object} line
     */
    debugHandler: function(line) {
        console.log(line);
    },
    
    /**
     * Formats file status
     * @param {Integer} status
     * @return {String}
     */
    formatStatus: function(status) {
        return this.strings.status[status];
    },
    
    /**
     * Formats raw bytes into kB/mB/GB/TB
     * @param {Integer} bytes
     * @return {String}
     */
    formatBytes: function(size) {
        if (!size) {
            size = 0;
        }
        var suffix = ["B", "KB", "MB", "GB"];
        var result = size;
        size = parseInt(size, 10);
        result = size + " " + suffix[0];
        var loop = 0;
        while (size / 1024 > 1) {
            size = size / 1024;
            loop++;
        }
        result = Math.round(size) + " " + suffix[loop];

        return result;

        if(isNaN(bytes)) {
            return ('');
        }

        var unit, val;

        if(bytes < 999) {
            unit = 'B';
            val = (!bytes && this.progressRequestCount >= 1) ? '~' : bytes;
        } else if(bytes < 999999) {
            unit = 'kB';
            val = Math.round(bytes/1000);
        } else if(bytes < 999999999) {
            unit = 'MB';
            val = Math.round(bytes/100000) / 10;
        } else if(bytes < 999999999999) {
            unit = 'GB';
            val = Math.round(bytes/100000000) / 10;
        } else {
            unit = 'TB';
            val = Math.round(bytes/100000000000) / 10;
        }

        return (val + ' ' + unit);
    },

    /**
     * SWFUpload swfUploadLoaded event
     */
    swfUploadLoaded: function() {
        if(this.debug) console.info('SWFUPLOAD LOADED');
        
        this.fireEvent('swfUploadLoaded', this);
    },
        
    /**
     * SWFUpload fileDialogStart event
     */
    fileDialogStart: function() {
        if(this.debug) console.info('FILE DIALOG START');
        
        this.fireEvent('fileDialogStart', this);
    },
    
    /**
     * Add file to store / grid
     * SWFUpload fileQueue event
     * @param {Object} file
     */
    fileQueue: function(file) {
        if(this.debug) console.info('FILE QUEUE');
        
        file.status = 0;
        r = new this.rec(file);
        r.id = file.id;
        this.store.add(r);
        
        this.fireEvent('fileQueued', this, file);
    },

    /**陈阳春
     * Error when file queue error occurs
     * SWFUpload fileQueueError event
     * @param {Object}  file
     * @param {Integer} code
     * @param {string}  message
     */
    fileQueueError: function(file, code, message) {
        if(this.debug) console.info('FILE QUEUE ERROR');

        switch (code) {
            case -100: 
                var slots;
                switch(message) {
                    case '0':
                        slots = this.strings.error_queue_slots_0;
                        break;
                    case '1':
                        slots = this.strings.error_queue_slots_1;
                        break;
                    default:
                        slots = String.format(this.strings.error_queue_slots_2, message);
                }
                Ext.MessageBox.alert(this.strings.text_error, String.format(this.strings.error_queue_exceeded + ' ' + slots, this.file_queue_limit));
                break;
                
            case -110:
                Ext.MessageBox.alert(this.strings.text_error, String.format(this.strings.error_size_exceeded, this.formatBytes(this.file_size_limit * 1024)));
                break;

            case -120:
                Ext.MessageBox.alert(this.strings.text_error, this.strings.error_zero_byte_file);
                break;

            case -130:
                Ext.MessageBox.alert(this.strings.text_error, this.strings.error_invalid_filetype);
                break;
        }
        this.fireEvent('fileQueueError', this, file, code, error);
    },

    /**
     * SWFUpload fileDialogComplete event
     * @param {Integer} file_count
     */
    fileDialogComplete: function(file_count) {
        if(this.debug) console.info('FILE DIALOG COMPLETE');
        
        if (file_count > 0) {
            this.uploadBtn.show();
        }
        
        this.addBtn.show();
		this.clearBtn.show();
        
        this.fireEvent('fileDialogComplete', this, file_count);
    },

    /**
     * SWFUpload uploadStart event
     * @param {Object} file
     */
    uploadStart: function(file) {
        if(this.debug) console.info('UPLOAD START');
        
        this.fireEvent('uploadStart', this, file);
        
        return true;
    },
    
    /**
     * SWFUpload uploadProgress event
     * @param {Object}  file
     * @param {Integer} bytes_completed
     * @param {Integer} bytes_total
     */
    uploadProgress: function(file, bytes_completed, bytes_total) {
        if(this.debug) console.info('UPLOAD PROGRESS');
        
        this.store.getById(file.id).set('status', 1);       
        this.store.getById(file.id).commit();
        this.progress_bar.updateProgress(bytes_completed/bytes_total, String.format(this.strings.text_uploading, file.name, this.formatBytes(bytes_completed), this.formatBytes(bytes_total)));
        
        this.fireEvent('uploadProgress', this, file, bytes_completed, bytes_total);
    },

    /**
     * SWFUpload uploadError event
     * Show notice when error occurs
     * @param {Object} file
     * @param {Integer} error
     * @param {Integer} code
     * @return {}
     */
    uploadError: function(file, error, code) {
        if(this.debug) console.info('UPLOAD ERROR');

        switch (error) {
            case -200:  
                Ext.MessageBox.alert(this.strings.text_error, this.strings.error_file_not_found);
                break;
                
            case -230:  
                Ext.MessageBox.alert(this.strings.text_error, this.strings.error_security_error);
                break;
                
            case -290:
                this.store.getById(file.id).set('status', 4);
                this.store.getById(file.id).commit();
                break;
        }
        
        this.fireEvent('fileUploadError', this, file, error, code);
    },

    /**上传成功处理事件
     * SWFUpload uploadSuccess event
     * @param {Object} file
     * @param {Object} response
     */ 
    uploadSuccess: function(file, response) 
    {
        if(this.debug) console.info('UPLOAD SUCCESS');
        
        var data = Ext.decode(response);
        if (data.success) 
        {
            this.store.getById(file.id).set('status', 2);//更新上传成功文件状态
           //this.store.remove(this.store.getById(file.id));//清空上传成功的文件队列
        }
        else  if(!data.success)
        {
            this.store.getById(file.id).set('status', 3);
            this.store.getById(file.id).commit();
            if (data.msg)
            {
                Ext.MessageBox.alert(this.strings.text_error, data.msg);
            }
        }
        
        
        this.fireEvent('fileUploadSuccess', this, file, data);
    },

    /**
     * SWFUpload uploadComplete event
     * @param {Object} file
     */
    uploadComplete: function(file) {
        if(this.debug) console.info('UPLOAD COMPLETE');
        
        this.progress_bar.reset();
        this.progress_bar.updateText(this.strings.text_progressbar);
        
        if(this.suo.getStats().files_queued && !this.upload_cancelled) 
        {
            this.suo.startUpload();
        } else 
        {
            this.fireEvent('fileUploadComplete', this, file);
            
            this.allUploadsComplete();
        }
        
    },
    
    /**
     * SWFUpload allUploadsComplete method
     */
    allUploadsComplete: function() {
        this.cancelBtn.hide();
		this.addBtn.show();
		this.clearBtn.show();
        
        this.fireEvent('allUploadsComplete', this);
    },
    
    /**
     * SWFUpload setPostParams method
     * @param {String} name
     * @param {String} value
     */
    addPostParam: function(name, value) {
        if (this.suo) {
            this.suo.settings.post_params[name] = value;
            this.suo.setPostParams(this.suo.settings.post_params);
        } else {
            this.post_params[name] = value;
        }
    },
        
    /**
     * Start file upload
     * SWFUpload startUpload method
     */
    startUpload: function() 
    {
        if(this.debug) console.info('START UPLOAD');
        
        this.cancelBtn.show();
        this.uploadBtn.hide();
        this.clearBtn.hide();
//		this.addBtn.hide();
        
        this.upload_cancelled = false;
        
		this.fireEvent('startUpload', this);
		
        this.suo.startUpload();
    },
    
    /**
     * SWFUpload stopUpload method
     * @param {Object} file
     */
    stopUpload: function(file) 
    {
        if(this.debug) console.info('STOP UPLOAD');
        
        this.suo.stopUpload();
        
        this.upload_cancelled = true;
        
        this.getStore().each(function() {
            if (this.data.status == 1) {
                this.set('status', 0);
                this.commit();
            }
        });

        this.cancelBtn.hide();
        if (this.suo.getStats().files_queued > 0) {
            this.uploadBtn.show();
        }
        this.addBtn.show();
		this.clearBtn.show();

        this.progress_bar.reset();
        this.progress_bar.updateText(this.strings.text_progressbar);

    },
    
    /**
     * Delete one or multiple rows
     * SWFUpload cancelUpload method
     */
    removeFiles: function()
    {
        if(this.debug) console.info('REMOVE FILES');
        var selRecords = this.getSelections();
        for (var i=0; i < selRecords.length; i++) 
        {
            if (selRecords[i].data.status != 1) 
            {
                this.suo.cancelUpload(selRecords[i].id);
                this.store.remove(selRecords[i]);
            }
        }
        
        if (this.suo.getStats().files_queued === 0) {
            this.uploadBtn.hide();
            this.clearBtn.hide();
        }
        
        this.fireEvent('removeFiles', this);
    },
    
    /**
     * Clear the Queue
     * SWFUpload cancelUpload method
     */
    removeAllFiles: function() {
        if(this.debug) console.info('REMOVE ALL');
        
        // mark all internal files as cancelled
        var files_left = this.suo.getStats().files_queued;

        while (files_left > 0) {
            this.suo.cancelUpload();
            files_left = this.suo.getStats().files_queued;
        }
        
        this.store.removeAll();
        
        this.cancelBtn.hide();
        this.uploadBtn.hide();
//        this.clearBtn.hide();
        
        this.fireEvent('removeAllFiles', this);
    }   
    
});