//=========================子窗口=============================

//创建编辑窗口(弹出)
//rowid :供应商rowid
function CreatePicListuploadWin(PictureData,PiclistData)
{
	if (undefined==PictureData.TRowID) {Msg.info("error","请选择主表");return}
	var TSourceType=PictureData.TSourceType
	if ((TSourceType!=CurrentSourceType)&&(PictureData!="")) {Msg.info("error","不允许跨业务录数据");return}
	//==========================================控件=====================================
	var PicListuploadWinPicSort=new Ext.form.NumberField({
		id:'PicListuploadWinPicSort',
		name:'PicSort',
    	fieldLabel:"序号",
    	allowDecimals:false,  //不允许输入小数
    	nanText:"请输入有效数字", //无效数字提示
    	allowNegative:false,       //不允许输入负数
    	width : 100,
		listWidth : 100,
		textWidth:100
   })
	var PicListuploadWinDefaultFlagField = new Ext.form.Checkbox({
		id : "PicListuploadWinDefaultFlagField",
		name : "DefaultFlag",
		autoScroll : false,
		width : 90,
		boxLabel : "默认显示",
		inputValue : "Y",
		anchor : "90%",
		hideLabel : true
		//为checkbox添加选中事件
}); 	
//============================面板==========================

	
	//布局面板
	var PicListuploadWinformPanel = new Ext.form.FormPanel({
		autoScroll:true,
		labelAlign : 'right',
		frame : true,
		region:'center',
		Height:150,
		style : 'margin:0px 0px 0px 0px;',
		//bodyStyle : 'padding:5px;',
		fileUpload:true, 	//3.3版本必须设置这个属性，4.2似乎不用
		items : [{
			//layout : 'column',横向，控件太多会导致强制换行，columnWidth : .33属性无效
			xtype : 'fieldset',
			title : '图片上传',
			Height:150,	
			//autoHeight : true,
			//layout:'form',		
			items : [{
				layout : 'column',
				items : [
					{columnWidth : .50,layout:'form',items :PicListuploadWinPicSort},
					{columnWidth : .50,layout:'form',items :PicListuploadWinDefaultFlagField}
				]},{
				layout : 'column',
				items : [
				{
					columnWidth : .50,
					style : 'margin:0px 0px 0px 4%;',//{top:0, right:0, bottom:0, left:0}
					xtype: 'textfield',   
					fieldLabel: '文 件',   
					name: 'FileStream' ,  
					inputType: 'file',   
					blankText: '请上传文件',   
					anchor: '90%' 
				},{
					style : 'margin:0px 0px 0px 4%;',
					xtype: 'button',//为了方便面板嵌套，button要写在items：[]里面不能写在button：[]里面
					text: '保存',
					disabled:(TSourceType!=CurrentSourceType)&&(PictureData!=""),
					handler:PicListuploadhandler 
				 }]
			}]
		}]
	});
	function PicListuploadhandler() 
					{
						var form = this.findParentByType("form").getForm();
						var PLRowID ="",PTRowID =""
						if (undefined!=PictureData.TRowID) PTRowID = PictureData.TRowID
						if (undefined!=PiclistData.TRowID) PLRowID = PiclistData.TRowID;
						if(form.isValid()){
							form.submit({
								url: '../csp/dhceq.process.pictureaction.csp?&actiontype=UploadByFtpStream'+'&PTRowID='+PTRowID+'&PLRowID='+PLRowID,		
								waitMsg: 'Uploading your file...',
								success: function(form, action)
								{
									Msg.info("",'Success' + action.result.result)
									UpdateForPicListChange()
								},
								failure: function(form, action) 
								{
									Msg.info("error",'failure'  + action.result.result)
								}
							});
						}
					}
	//========================窗体========================
	
	//初始化窗口
	var PicListuploadWinwindow = new Ext.Window({
		title:'图片明细上传',
		width:550,
		height:150,
		minWidth:600,
		minHeight:400,
		//layout:'fit',
		plain:true,
		modal:true,
		layout:'border',
		//autoScroll:true,
		bodyStyle :'overflow-x:hidden;overflow-y:scroll',//禁用水平滚动条防止插入图片时内部面板太宽
		items:[PicListuploadWinformPanel]
	});
	
	
	PicListuploadWinwindow.show();	//将window的控件单独写在一个js方法行不通，估计与变量作用域以及旧的windowFram元素没有完全删除有关
	//==============================功能函数==================================
	//=====================初始化=====================
	function SetPiclistInfo()
	{
		if (PiclistData!="")
		{
			Ext.getCmp('PicListuploadWinPicSort').setValue(PiclistData.TPicListSort)
			Ext.getCmp('PicListuploadWinDefaultFlagField').setValue(PiclistData.TDefaultFlag)
		}
	}
	SetPiclistInfo()
	
	
	
	
	
		
	
	
}