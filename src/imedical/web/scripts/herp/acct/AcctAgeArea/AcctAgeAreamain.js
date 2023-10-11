var userid=session['LOGON.USERID'];
var bookID=IsExistAcctBook();

//保存按钮
var saveButton = new Ext.Toolbar.Button({
	text:'保存',
	tooltip:'保存更改',
	iconCls: 'save',
	handler:function(){
		var rowObj=AcctAgeareamain.getSelectionModel().getSelections();
		var beginDays=rowObj[0].get("beginDays");
		var endDays=rowObj[0].get("endDays");
		if((/^[0-9]+$/.test(beginDays))&&(/^[0-9]+$/.test(endDays))){//这是用正则表达是检查
			//调用保存函数
			AcctAgeareamain.save();
		}else if(beginDays=="" || endDays==""){
			Ext.Msg.show({
					title: '错误',
					msg: '【起始天数】和【终止天数】不能为空 ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
		}else{					
			//alert('请填写【起始天数】和【终止天数】为数字！');
			Ext.Msg.show({title: '注意',msg: '请填写【起始天数】和【终止天数】为数字！',
				buttons: Ext.Msg.OK,icon: Ext.MessageBox.INFO
			});
		}		
	}
});

var AcctAgeareamain= new dhc.herp.Grid({
	   title: '往来账账龄区间管理',
	   iconCls:'maintain',
       // width: 400,
        //edit:false,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.acctageareaexe.csp',	  
		//atLoad : true, // 是否自动刷新
		tbar:saveButton,
		loadmask:true,
        fields: [{
			id:'rowid',
			header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'code',
            header: '<div style="text-align:center">区间编号</div>',
			allowBlank: false,
			width:200,
			align: 'center',
            dataIndex: 'code'
        },{
            id:'describe',
            header: '<div style="text-align:center">区间描述</div>',
			allowBlank: false,
			align: 'center',
			width:200,
            dataIndex: 'describe'
        },{
            id:'beginDays',
            header: '<div style="text-align:center">起始天数</div>',
			allowBlank: false,
			align: 'center',
			width:200,
            dataIndex: 'beginDays'
        },{								
            id:'endDays',
            header: '<div style="text-align:center">终止天数</div>',
            allowBlank: false,
			width:200,
			align: 'center',
            dataIndex: 'endDays'
        }] 
});

AcctAgeareamain.load({
		    params:{
		    start:0,
		    limit:25,		    
			bookID:bookID
		   }
		  });

AcctAgeareamain.on('afteredit', afterEdit, this );

    function afterEdit(e) {
	
        // execute an XHR to send/commit data to the server, in callback do (if successful):
//    	grid - This grid
//    	record - The record being edited
//    	field - The field name being edited
//    	value - The value being set
//    	originalValue - The original value for the field, before the edit.
//    	row - The grid row index
//    	column - The grid column index
        var utotal = AcctAgeareamain.getStore().getCount();
		if (utotal>1){
			var total=utotal-2;
			var endDays=AcctAgeareamain.getStore().getAt(total).get('endDays');
			if(e.field=="describe"){
				// alert(parseInt(endDays));
				if((e.value!="")&&(endDays!="")){
					e.record.set("beginDays",parseInt(endDays)+1);
				}
			}
			
		}    
    };

	AcctAgeareamain.btnSaveHide()    //隐藏保存按钮
    AcctAgeareamain.btnResetHide() ;    //隐藏重置按钮
    AcctAgeareamain.btnPrintHide()  ;   //隐藏打印按钮
