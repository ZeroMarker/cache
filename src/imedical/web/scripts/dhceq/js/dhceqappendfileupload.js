//GR0046 extjs 文件上传
//文件上传调用上传界面代码
//关联csp：dhceq.process.AppendFile.csp
//=========================子窗口=============================
function CreateAppendFileuploadWin(AppendFileData)
{
	var AFformAppendFile=	new Ext.dhceq.AppendFileTypeComboBox({id:'AFformAppendFile',hiddenName:'AppendFileTypeDR'});
	AFformAppendFile.store.load(
			{params:{start:0,limit:20},
			callback : function(r, options, success) {
				SetAppendFileInfo()
			},
			scope: CreateAppendFileuploadWin, //Scope用来指定回调函数执行时的作用域
           	//Add为true时，load()得到的数据会添加在原来的store数据的末尾，
          	//否则会先清除之前的数据，再将得到的数据添加到store中
　　add: false //ensemble的js编译器对空白处理不太给力
	})
	var AFformDocName=	new Ext.form.TextField({		
					id:'AFformDocName',
					name:'DocName',
					fieldLabel: '资料名称',
					selectOnFocus:true
				  }); 		           	
	var AFformRemark=	new Ext.form.TextField({		
					id:'AFformRemark',
					name:'Remark',
					fieldLabel: '备注',
					selectOnFocus:true
				  });
				  
	//============================面板==========================

	
	//布局面板
	var AFformPanel = new Ext.form.FormPanel({
	labelwidth : 30,
	autoScroll:true,
	//Height:500,
	labelAlign : 'right',
	frame : true,
	bodyStyle : 'padding:5px;',
	fileUpload:true, 	
    items : [{
		//xtype : 'fieldset',
		//title : '上传选项',
		autoHeight : true,
		//layout : 'column',			
		items : [{
				layout : 'column',
				items : [
					{columnWidth : .33,layout:'form',items :AFformAppendFile},
					{columnWidth : .33,layout:'form',items :AFformDocName},
					{columnWidth : .33,layout:'form',items :AFformRemark}
					
				]},{
				layout : 'column',
				items : [
				{
					columnWidth : .46,
					//width:300,
					style : 'margin:0px 0px 0px 4%;',//{top:0, right:0, bottom:0, left:0}
					xtype: 'textfield',   
					fieldLabel: '文 件',   
					name: 'FileStream' ,  
					inputType: 'file',  
					//allowBlank: false,   
					blankText: '请上传文件',   
					anchor: '90%' 
					}
				]},{
				layout : 'column',
				items : [{
					style : 'margin:0px 0px 0px 5%;',
					xtype: 'button',//为了方便面板嵌套，button要写在items：[]里面不能写在button：[]里面
					iconCls:'page_edit',
					text: '保存',
					handler:formhandler //由于Ensemble的js编辑器效率低下，所以这个函数移到外面
				}
				]
				}
		]
	}]
});
	function formhandler() 
	{
		var form = this.findParentByType("form").getForm();
		var RowID ="",SourceType=CurrentSourceType,SourceID=CurrentSourceID
		if (undefined!=AppendFileData.TRowID) {RowID = AppendFileData.TRowID;SourceType=AppendFileData.TSourceType;SourceID=AppendFileData.TSourceID}
		if(form.isValid()){
			form.submit({
				url: '../csp/dhceq.process.appendfileaction.csp?&actiontype=UploadByFtpStream&RowID='+RowID+'&SourceType='+SourceType+'&SourceID='+SourceID,		//3.3版本URl写在这里
				waitMsg: 'Uploading your file...',
				success: function(form, action)
				{
					Msg.info("",'Success' + action.result.result)
					UpdateForAppendFileChange()
					//PicListGrid.store.load({params:{start:0,limit:PicListPagingToolbar.pageSize}})
				},
				failure: function(form, action) 
				{
					Msg.info("error",'failure'  + action.result.result)
				}
			});
			
		}
		else Msg.info("error","表单不全")
	}
	//========================窗体========================
	
	//初始化窗口
	var AFSimpleuploadwindow = new Ext.Window({
		title:'主文件信息',
		width:800,
		height:200,
		minWidth:600,
		minHeight:400,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle :'overflow-x:hidden;overflow-y:scroll',//禁用水平滚动条防止插入图片时内部面板太宽
		items:[AFformPanel],
		
		listeners:{
			'close':function(){
				}
			}
	});
	
	
	AFSimpleuploadwindow.show();	//将window的控件单独写在一个js方法行不通，估计与变量作用域以及旧的windowFram元素没有完全删除有关
	//==============================功能函数==================================
	function SetAppendFileInfo()
	{
		if (AppendFileData!="")
		{
			
			Ext.getCmp('AFformAppendFile').setValue(AppendFileData.TAppendFileTypeDR)
			Ext.getCmp('AFformDocName').setValue(AppendFileData.TDocName)
			Ext.getCmp('AFformRemark').setValue(AppendFileData.TRemark)
		}
	}
}
